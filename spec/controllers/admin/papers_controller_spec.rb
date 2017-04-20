require 'rails_helper'

RSpec.describe Admin::PapersController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      @admin = create :admin
      sign_in @admin
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
