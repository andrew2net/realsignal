require 'rails_helper'

RSpec.describe 'twocheckout webhooks POST /tcwc', type: :request do
  let(:data) do
    sale_id = '9093740401218'
    invoice_id = '9093740401227'
    md5_hash = Digest::MD5.hexdigest sale_id + Figaro.env.twocheckout_seller_id +
      invoice_id + Figaro.env.twocheckout_secret_word
    {
      sale_id:    sale_id,
      invoice_id: invoice_id,
      md5_hash:   md5_hash.upcase,
    }
  end

  it 'should fail authorization' do
    data[:sale_id] = '9093740401219'
    post '/tcwh', params: data
    expect(response).to have_http_status :unauthorized
  end

  describe 'invoice status change' do
    let(:subscription) { create :subscription, status: :processing }
    let(:invoice_status_change_data) do
      data.merge(
        message_type:   'INVOICE_STATUS_CHANGED',
        invoice_status: 'deposited',
        vendor_order_id: subscription.id
      )
    end

    it 'should set subscription status to subscribed' do
      post '/tcwh', params: invoice_status_change_data
      expect(response).to have_http_status :no_content
      subscription.reload
      expect(subscription.status).to eq 'subscribed'
      end_date = Date.today + 1.send(subscription.subscription_type.period.downcase)
      expect(subscription.end_date).to eq end_date
    end

    it 'should set end date to subscription counted form previous not ended subscription with same strategy' do
      user = subscription.user
      subscription_type = create( :subscription_type,
        portfolio_strategy: subscription.subscription_type.portfolio_strategy
      )
      prev_subscription = create( :subscription,
        user:              user,
        subscription_type: subscription_type,
        status:            :stopped,
        end_date:          Date.today + 4.days
      )
      post '/tcwh', params: invoice_status_change_data
      expect(response).to have_http_status :no_content
      subscription.reload
      end_date = prev_subscription.end_date + 1.send(subscription.subscription_type.period.downcase)
      expect(subscription.end_date).to eq end_date
    end
  end

  describe 'recurring stop' do
    let(:subscription) { create :subscription, status: :stopping }
    let(:recurring_stop_data) do
      data.merge(
        message_type:    'RECURRING_STOPPED',
        vendor_order_id: subscription.id
      )
    end

    it 'should set subscription status to stopped' do
      post '/tcwh', params: recurring_stop_data
      expect(response).to have_http_status :no_content
      subscription.reload
      expect(subscription.status).to eq 'stopped'
    end
  end
end
