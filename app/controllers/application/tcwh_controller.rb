class Application::TcwhController < ApplicationController
  def webhook
    resp = Twocheckout::ValidateResponse.notification(
      sale_id:    params[:sale_id],
      vendor_id:  Figaro.env.twocheckout_seller_id,
      invoice_id: params[:invoice_id],
      secret:     Figaro.env.twocheckout_secret_word,
      md5_hash:   params[:md5_hash]
    )

    if resp[:code] == "PASS"
      case params[:message_type]
      when "ORDER_CREATED"
      end
      head :no_content
    else
      head :unauthorized
    end
  end
end
