require 'rails_helper'
require 'telegram/bot/rspec/integration'

RSpec.describe "TelegramController", type: :request do
  describe "POST /telegram/bot_id" do
    include_context 'telegram/bot/integration'

    describe '#start' do
      let(:token) { SecureRandom.urlsafe_base64 4 }

      before(:each) do
        user = create :user
        Rails.cache.write token, user.id, expired_in: 5.minutes
      end

      it "token is valid" do
        expect {
          dispatch_command :start, token
        }.to respond_with_message 'Hello! Welcome to chat with RealSignal bot.'

        expect(response).to have_http_status(200)
      end

      it 'token is invalid' do
        expect {
          dispatch_command :start, token + 'z'
        }.to respond_with_message 'Token is invalid. Try to genarate new access link on /account/subscription'

        expect(response).to have_http_status(200)
      end
    end
  end
end
