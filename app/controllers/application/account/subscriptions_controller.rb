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

  def success
    resp = Twocheckout::ValidateResponse.purchase(
      sid:          Figaro.env.twocheckout_seller_id,
      secret:       Figaro.env.twocheckout_secret_word,
      order_number: params[:order_number],
      total:        params[:total],
      key:          params[:key]
    )
    if resp[:code] == "PASS"
      Subscription.update params[:merchant_order_id], sale_id: params[:sale_id]
      update_billing_addrr billing_addr_form_2co
      redirect_to :index, notice: "The order was successfully created."
    else
      redirect_to account_subscription_url(params[:merchant_order_id]), notice: "Validation failed."
    end
  end

  def save_billing_addr
    update_billing_addrr billing_addr_params
    current_user.update first_last_name_params
    head :ok
  end

  private

  def billing_addr_params
    params.permit :addr_line_1, :addr_line_2, :city, :state, :zip_code, :country, :phone, :phone_ext
  end

  def billing_addr_form_2co
    {
      addr_line_1: params[:street_address],
      addr_line_2: params[:street_address2],
      city:        params[:city],
      state:       params[:state],
      zip_code:    params[:zio],
      country:     params[:country],
      phone:       params[:phone],
      phone_ext:   params[:phone_ext]
    }
  end

  def update_billing_addrr(billing_addr)
    if current_user.address
      current_user.address.update billing_addr
    else
      current_user.address = Address.create billing_addr
    end
  end

  def first_last_name_params
    params.permit :first_name, :last_name
  end
end
