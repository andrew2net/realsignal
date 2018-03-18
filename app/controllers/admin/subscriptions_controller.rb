class Admin::SubscriptionsController < ApplicationController
  layout 'admin'

  def index
    respond_to do |format|
      format.html { render 'admin/main/index' }
      format.json { render json: Subscription.all, only: attrs }
    end
  end

  def create
    render json: Subscription.create(subscription_params), only: attrs
  end

  def update
    render json: Subscription.update(params[:id], subscription_params), only: attrs
  end

  def destroy
    Subscription.destroy params[:id]
    head :ok
  end

  private

  def attrs
    [:id, :subscription_type_id, :user_id, :status, :end_date]
  end

  def subscription_params
    params.require(:subscription).permit attrs
  end
end
