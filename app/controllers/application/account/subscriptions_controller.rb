class Application::Account::SubscriptionsController < Application::Account::AccountController
  def index
    render "application/account/dashboard/index"
  end
end
