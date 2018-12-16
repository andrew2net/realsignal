# frozen_string_literal: true

module Application
  module Api
    # Mobile app qpi controller.
    class AppApiController < ApplicationController
      # POST /api/sign_in
      def signin
        user = User.find_by_email params[:email]
        if user&.valid_password? params[:password]
          token = user.token_generate
          render plain: token
        else
          head :unauthorized
        end
      end
    end
  end
end
