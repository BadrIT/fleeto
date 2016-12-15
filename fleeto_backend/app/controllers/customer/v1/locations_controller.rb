class Customer::V1::LocationsController < Customer::V1::BaseController

  def set_location
    Customers::LocationService.new(current_customer).set_location(long: params[:long], lat: params[:lat])
    head :no_content
  end

  def locate_near_drivers
    customer_location = Customers::LocationService.new(current_customer).get_location
    @drivers_locations = Drivers::LocationService.get_drivers_locations_within(params[:distance], customer_location)
    @drivers_locations.select!{|driver_info| !driver_info[:driver].in_a_trip?}
    render json: @drivers_locations    
  end

end