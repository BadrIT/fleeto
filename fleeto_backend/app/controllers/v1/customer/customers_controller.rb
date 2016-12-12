class V1::Customer::CustomersController < BaseController

  before_action :set_customer, only: [:verify]

  def verify
    if params[:verification_code] == @customer.verification_code
      @customer.update_columns(verified: true)
      render json: {},  status: :ok
    else
      @customer.generate_verification_code!
      render json: {}, status: 401
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end
  
end