class Customer::V1::CustomersController < Customer::V1::BaseController

  skip_before_action :check_customer_is_verified!, only: [:verify]

  def verify
    if params[:verification_code] == current_customer.verification_code
      current_customer.verify!
      render json: {message: "Successfully verified account!"},  status: :ok
    else
      render json: {message: "Wrong verification code"}, status: :unprocessable_entity
    end
  end

  
end