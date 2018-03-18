require 'rails_helper'

RSpec.describe "Application::Account::SubscriptionsController", type: :request do
  let(:user) { create :user }

  before(:each) do
    sign_in user
  end

  describe "GET /account/subscriptions" do
    it "render user's subscriptions page" do
      get account_subscriptions_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /account/subscriptions/has_available_plans' do
    it "return plans with portfolio strategy wich user doesn't subscribe" do
      portfolio_strategy = create :portfolio_strategy_with_subscription_types

      get has_available_plans_account_subscriptions_path
      expect(response).to have_http_status :success
      expect(JSON.parse(response.body)['has_available_plans']).to be_truthy

      create(:subscription,
        user: user,
        subscription_type: portfolio_strategy.subscription_types.first,
        status: :subscribed
      )
      get has_available_plans_account_subscriptions_path
      expect(JSON.parse(response.body)['has_available_plans']).to be_falsey
    end
  end
end
