class Admin::UsersController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def index
    respond_to do |format|
      format.html { render 'admin/main/index' }
      format.json {
        render json: User.all, only: [:id, :first_name, :last_name, :email]
      }
    end
  end

  def create
    user = User.new user_params
    user.skip_confirmation!
    user.save
    head :ok
  end

  def update
    User.update params[:id], user_params
    head :ok
  end

  def destroy
    User.destroy params[:id]
    head :ok
  end

  protected
  def user_params
    params.permit :id, :first_name, :last_name, :email, :password,
      :password_confirmation
  end
end
