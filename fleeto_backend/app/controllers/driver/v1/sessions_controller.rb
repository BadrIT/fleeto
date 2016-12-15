class Driver::V1::SessionsController < DeviseTokenAuth::SessionsController
  
  protected

  def render_create_success
    render json: @resource
  end

  def resource_name
    :driver
  end

end
