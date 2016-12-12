class V1::Customer::RegistrationsController < DeviseTokenAuth::RegistrationsController

  before_action :configure_sign_up_params, only: [:create]

  respond_to :json

  def create
    super do |resource|
      if resource.persisted?
        # TODO
        # Run a delayed job to send confirmation sms to the user
        # myservice.send_sms_confirmation
        # for now we will just set him as verified
        resource.update_columns(is_verified: true)
      end
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:mobile, :name])
  end

  # need to override it, as by default it will return v1_users
  def resource_name
    :customer
  end

end