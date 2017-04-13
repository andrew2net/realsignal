class Admin::SessionsController < Devise::SessionsController
  layout 'admin'
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
  #   super
    render 'admin/main/index'
  end

  # POST /resource/sign_in
  def create
    # super
    result = Admin.find_and_auth session_params
    if result
      sign_in :admin_admin, result
    end
    render json: { result: (not result.nil?) }
  end

  # DELETE /resource/sign_out
  def destroy
    result = sign_out(:admin_admin)
    render json: {result: result}
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def session_params
    params.permit :email, :password, :remember_me
  end
end
