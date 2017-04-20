class Admin::StrategiesController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def index
    respond_to do |f|
      f.html { render 'admin/main/index' }
      f.json { render json: Strategy.all, only: attrs }
    end
  end

  def create
    render json: Strategy.create(strategy_params), only: attrs
  end

  def update
    render json: Strategy.update(params[:id], strategy_params), only: attrs
  end

  def destroy
    Strategy.destroy params[:id]
    head :ok
  end

  protected
  def attrs
    [:id, :name, :leverage, :portfolio_strategy_id, :tool_id]
  end

  def strategy_params
    params.require(:strategy).permit attrs
  end
end
