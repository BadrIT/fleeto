class V1::Customer::DriversController < V1::Customer::BaseController

  def locate_near_drivers
    @drivers = Customers::Drivers::LocateNearDriversService.new(current_customer).execute
    render json: @drivers    
  end

end