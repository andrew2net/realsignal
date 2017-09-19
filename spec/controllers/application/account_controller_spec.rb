require 'rails_helper'

RSpec.describe Application::AccountController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      @user = create :user
      sign_in @user, scope: :user
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
