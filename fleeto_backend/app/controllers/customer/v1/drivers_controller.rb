class Customer::V1::DriversController < Customer::V1::BaseController

  def locate_near_drivers
    @drivers = Customers::Drivers::LocateNearDriversService.new(current_customer).execute
    render json: @drivers    
  end

end