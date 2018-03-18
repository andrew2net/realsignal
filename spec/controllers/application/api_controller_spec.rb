require 'rails_helper'

RSpec.describe 'application api', type: :request do
  it 'GET /api/views/:view render view' do
    get api_path(view: 'main')
    expect(response).to have_http_status :success
  end

  it 'GET /api/strategies return json array with strategies' do
    get api_strategies_path
    expect(response).to have_http_status :success
  end

  it 'GET /api/equity_growth return array of hashes for chart' do
    strategy = create :strategy_with_recom_signals
    get api_equity_growth_path, params: { strategy: strategy.id }
    expect(response).to have_http_status :success
  end

  it 'GET /api/telegram_token return token for Telegram bot registration' do
    user = create :user
    sign_in user
    get api_telegram_token_path
    expect(response).to have_http_status :success
  end
end
