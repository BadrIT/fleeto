class V1::Customer::SessionsController < DeviseTokenAuth::SessionsController
  

  protected

  def render_create_success
    render json: @resource
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:mobile, :name])
  end
end
