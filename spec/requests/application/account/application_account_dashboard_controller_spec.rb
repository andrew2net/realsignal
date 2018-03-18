require 'rails_helper'

RSpec.describe "Application::Account::DashboardController", type: :request do
  describe "GET /account/dashboard" do
    it "if user signed in then render user dashboard page" do
      sign_in create :user
      get account_dashboard_path
      expect(response).to have_http_status(200)
    end

    it 'if user not signed in then redirect to /users/sign_in' do
      get account_dashboard_path
      expect(response).to redirect_to new_user_session_path
    end
  end
end
