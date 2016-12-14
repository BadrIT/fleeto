class Customer::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_update_params, only: [:update]

  respond_to :json

  def create
    super do |resource|
      if resource.persisted?
        resource.generate_verification_code!
        sms_message = "Your Fleeto Confirmation code is: #{resource.verification_code}"
        SendSmsJob.perform_later(resource, sms_message)
      end
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:mobile, :name])
  end

  def configure_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def render_create_success
    render json: @resource, status: :created
  end

end