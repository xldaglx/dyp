class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
  before_filter :configure_permitted_parameters

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
      super
      ExampleMailer.welcome_email(@user).deliver
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :nickname, :avatar)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:password, :password_confirmation, :email, :nickname, :avatar)
    end
  end
  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
