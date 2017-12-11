require 'equity_growth'

class Application::ApiController < ApplicationController
  def views
    render params[:view], layout: false
  end

  def strategies
    render json: Strategy.all, only: [:id, :name]
  end

  def equity_growth
    strategy = Strategy.find params[:strategy]
    render json: EquityGrowth.calc_data(strategy)
  end

  def telegram_token
    token = SecureRandom.urlsafe_base64 4
    Rails.cache.write token, current_user.id, expired_in: 5.minutes
    render plain: token
  end

end
