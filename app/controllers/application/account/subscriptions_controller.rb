class Application::Account::SubscriptionsController < Application::Account::AccountController

  # GET /account/subscriptions
  def index
    respond_to do |f|
      f.html { render "application/account/dashboard/index" }
      f.json { @subscriptions = current_user.subscriptions.includes(subscription_type: :portfolio_strategy) }
    end
  end

  # GET /account/subscriptions/has_available_plans
  def has_available_plans
    render json: { has_available_plans: SubscriptionType.available(current_user).any? }
  end

  # GET /account/subscriptions/select_plan
  def select_plan
    render "application/account/dashboard/index"
  end

  # GET /account/subscriptions/plans
  def plans
    # Select plans with strategies which user doesn't subscribe yet.
    @plans = SubscriptionType.includes(:portfolio_strategy).available current_user
  end

  # POST /account/subscriptions
  def create
    subscription = Subscription.create subscription_type_id: params[:plan], user_id: current_user.id
    render json: { subscription_id: subscription.id }
  end

  # GET /account/subscriptions/:id
  def show
    respond_to do |f|
      f.html { render "application/account/dashboard/index" }
      f.json { @subscription = Subscription.find params[:id] }
    end
  end

  # GET /account/subscriptions/success
  def success
    resp = Twocheckout::ValidateResponse.purchase(
      sid:          Figaro.env.twocheckout_seller_id,
      secret:       Figaro.env.twocheckout_secret_word,
      order_number: params[:order_number],
      total:        params[:total],
      key:          params[:key]
    )
    if resp[:code] == "PASS"
      Subscription.update params[:merchant_order_id], status: :processing
      update_billing_addrr billing_addr_form_2co
      redirect_to account_subscriptions_path, notice: "The order was successfully created."
    else
      redirect_to account_subscription_path(params[:merchant_order_id]), notice: "Validation failed."
    end
  end

  # POST /account/subsriptions/:id/stop
  def stop
    Twocheckout::API.credentials = {
      :username => Figaro.env.twocheckout_username,
      :password => Figaro.env.twocheckout_password,
      :sandbox => (Figaro.env.twocheckout_env == 'sandbox' ? 1 : 0)
    }
    subscription = Subscription.find params[:id]
    sale = Twocheckout::Sale.find sale_id: subscription.sale_id
    last_invoice = sale.invoices.last
    last_lineitem = last_invoice.lineitems.last
    resp = last_lineitem.stop_recurring!
    if resp['response_code'] == 'OK'
      subscription.update status: :stopping
    end
    render partial: 'subscription', locals: { subscription: subscription }
  rescue Exception => e
    logger.fatal e.message
    head :unprocessable_entity
  end

  # GET /account/subscriptions/billing_addr
  def billing_addr
    @user = current_user
  end

  # POST /account/subscriptions/billing_addr
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
      zip_code:    params[:zip],
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
