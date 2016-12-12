class V1::Customer::CustomersController < V1::Customer::BaseController

  skip_before_action :check_customer_is_verified!, only: [:verify]

  def verify
    if params[:verification_code] == current_customer.verification_code
      current_customer.update_columns(is_verified: true)
      render json: {message: "Successfully verified account!"},  status: :ok
    else
      render json: {}, status: 401
    end
  end

  
end