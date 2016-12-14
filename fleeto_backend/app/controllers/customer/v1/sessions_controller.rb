class Customer::V1::SessionsController < DeviseTokenAuth::SessionsController
  
  protected

  def render_create_success
    render json: @resource
  end

  def resource_name
    :customer
  end

end
