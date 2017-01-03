class Admin::SubscriptionTypesController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def view
    render 'admin/main/index'
  end

  def index
    render json: SubscriptionType.all, only: attrs
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

  protected
  def attrs
    [:id, :portid, :symid, :price, :description]
  end

  def subscription_type_params
    params.permit :id, :portid, :symid, :price, :description
  end
end
