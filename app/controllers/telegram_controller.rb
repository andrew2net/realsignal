class TelegramController < Telegram::Bot::UpdatesController

  # Register user's chat
  def start(data = nil, *)
    Rails.logger.debug { "Telegram: #{data}" }
    user_id = Rails.cache.read data
    Rails.cache.delete data
    user = User.find_by_id user_id
    if user
      user.update chat_id: payload[:chat][:id]
      respond_with(:message, text: "Hello! Welcome to chat with RealSignal bot.")
    else
      respond_with(:message, text: "Token is invalid. Try to genarate new access link on /account/subscription")
    end
  end
end
