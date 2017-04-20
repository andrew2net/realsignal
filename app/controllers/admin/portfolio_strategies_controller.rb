class Admin::PortfolioStrategiesController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def index
    respond_to do |f|
      f.html { render 'admin/main/index' }
      f.json { render json: PortfolioStrategy.all, only: attrs }
    end
  end

  def create
    render json: PortfolioStrategy.create(portfolio_strategy_params), only: attrs
  end

  def update
    render json: PortfolioStrategy.update(params[:id], portfolio_strategy_params),
      only: attrs
  end

  def destroy
    PortfolioStrategy.destroy params[:id]
    head :ok
  end

  protected

  def attrs
    [:id, :name]
  end

  def portfolio_strategy_params
    params.permit attrs
  end
end
