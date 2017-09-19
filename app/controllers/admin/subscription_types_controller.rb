class Admin::SubscriptionTypesController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def index
    respond_to do |format|
      format.html { render 'admin/main/index' }
      format.json { @subscription_types = SubscriptionType.all }
    end
  end

  def create
    render json: SubscriptionType.create(subscription_type_params), only: attrs
  end

  def update
    render json: SubscriptionType.update(params[:id], subscription_type_params),
      only: attrs
  end

  def destroy
    SubscriptionType.destroy params[:id]
    head :ok
  end

  def periods
    render json: SubscriptionType.periods.map { |k, v| { id: v, name: k } }
  end

  protected
  def attrs
    [:id, :portfolio_strategy_id, :period, :price]
  end

  def subscription_type_params
    params.permit attrs
  end
end
