class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def view
    render 'admin/main/index'
  end

  def index
    render json: Admin.all, only: [:id, :email]
  end

  def create
    Admin.create admin_params
    head :ok
  end

  def update
    Admin.update params[:id], admin_params
    head :ok
  end

  def destroy
    Admin.destroy params[:id]
    head :ok
  end

  protected
  def admin_params
    params.permit :id, :email, :password, :password_confirmation
  end
end
