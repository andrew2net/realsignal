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
end
