class Customer::V1::DriversController < Customer::V1::BaseController

  def locate_near_drivers
    @drivers_locations = Customers::LocationService.new(current_customer).get_drivers_locations_within(params[:distance])
    @drivers_locations.select!{|driver_info| !driver_info[:driver].in_a_trip?}
    render json: @drivers_locations    
  end

end