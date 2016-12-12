class V1::Customer::CustomersController < V1::Customer::BaseController

  before_action :set_customer, only: [:verify]
  skip_before_action :check_customer_is_verified!, only: [:verify]

  def verify
    if params[:verification_code] == @customer.verification_code
      @customer.update_columns(is_verified: true)
      render json: {message: "Successfully verified account!"},  status: :ok
    else
      render json: {}, status: 401
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end
  
end