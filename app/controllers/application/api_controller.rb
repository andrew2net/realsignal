require 'equity_growth'

class Application::ApiController < ApplicationController

  # GET /api/views/:view
  def views
    render params[:view], layout: false
  end

  # GET /api/strategies
  def strategies
    render json: Strategy.all, only: [:id, :name]
  end

  # GET /api/equity_growth
  def equity_growth
    strategy = Strategy.find params[:strategy]
    render json: EquityGrowth.calc_data(strategy)
  end

  # GET /api/telegram_token
  def telegram_token
    token = SecureRandom.urlsafe_base64 4
    Rails.cache.write token, current_user.id, expired_in: 5.minutes
    render plain: token
  end

end
