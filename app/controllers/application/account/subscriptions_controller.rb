class Application::Account::SubscriptionsController < Application::Account::AccountController
  def index
    render "application/account/dashboard/index"
  end

  def select_plan
    render "application/account/dashboard/index"
  end

  def plans
    @plans = SubscriptionType.includes(:portfolio_strategy)
  end

  def create
    subscription = Subscription.create subscription_type_id: params[:plan], user_id: current_user.id
    render json: { subscription_id: subscription.id }
  end

  def show
    respond_to do |f|
      f.html { render "application/account/dashboard/index" }
      f.json { @subscription = Subscription.find params[:id] }
    end
  end

  def billing_addr
    @user = current_user
  end

  def twocheckout_pay
    subscription = Subscription.find params[:subscription_id]
    Twocheckout::API.credentials = {
      seller_id:   ENV["twocheckout_seller_id"],
      private_key: ENV["twocheckout_private_key"],
      sandbox: 1 # ENV["tocheckout_env"] == "sandbox"
    }

    if current_user.address
      current_user.address.update billing_addr_params
    else
      current_user.address = Address.create billing_addr_params
    end

    current_user.update first_last_name_params

    billing_addr = billing_addr_params.transform_keys { |k| k.to_s.camelize :lower }
    billing_addr[:name] = params[:billing_addr][:first_name] + ' ' + params[:billing_addr][:last_name]
    billing_addr[:email] = current_user.email

    pay_data = {
      merchantOrderId: params[:subscription_id],
      token: params[:token],
      currency: "EUR",
      # total: subscription.subscription_type.price.to_s,
      billingAddr: billing_addr.to_h.symbolize_keys.select { |_k, v| !v.nil? },
      lineItems: [
        {
          type: "product",
          name: subscription.name,
          quantity: 1,
          price: subscription.subscription_type.price.to_s,
          tangible: "N",
          productId: subscription.subscription_type.id.to_s,
          recurrence: "1 #{subscription.subscription_type.period}",
          duration: "Forever"
        }
      ]
    }
  
    result = Twocheckout::Checkout.authorize pay_data
    render json: result, only: [:responseMsg, :responseCode]
  rescue Exception => e
    render json: { responseMsg: e.message, responseCode: "EXCEPTION" }
  end

  private

  def billing_addr_params
    params.require(:billing_addr).permit :addr_line_1, :addr_line_2, :city, :state, :zip_code, :country, :phone, :phone_ext
  end

  def first_last_name_params
    params.require(:billing_addr).permit :first_name, :last_name
  end
end
