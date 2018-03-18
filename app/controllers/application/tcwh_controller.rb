class Application::TcwhController < ApplicationController

  # POST /tcwh
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
      when "INVOICE_STATUS_CHANGED"
        if params[:invoice_status] == 'deposited'
          subscription = Subscription.find params[:vendor_order_id]

          # Seach for previous subscription with the same strategy.
          prev_subscription = subscription.user.subscriptions.joins(:subscription_type)
          .where(subscription_types: {
            portfolio_strategy_id: subscription.subscription_type.portfolio_strategy_id
          }).where.not(id: subscription.id).order(:end_date).last

          # If there is prev subscription and it not ended then new period start
          # after prev end data, otherwise start form today.
          end_date = Date.today
          if prev_subscription && prev_subscription.end_date > end_date
            end_date = prev_subscription.end_date
          end
          end_date += 1.send(subscription.subscription_type.period.downcase)

          subscription.update status: :subscribed, sale_id: params[:sale_id], end_date: end_date
        end
      when "RECURRING_STOPPED"
        Subscription.update params[:vendor_order_id], status: :stopped
      end
      head :no_content
    else
      head :unauthorized
    end
  end
end
