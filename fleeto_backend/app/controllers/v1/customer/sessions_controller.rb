class V1::Customer::SessionsController < Devise::SessionsController
  
  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:mobile, :name])
  end
end
