class Customer::V1::LocationsController < Customer::V1::BaseController

  def set_location
    Customers::LocationService.new(current_customer).set_location(long: params[:long], lat: params[:lat])
    head :no_content
  end

  def distance_matrix_to_drop_off_location
    customer_location = Customers::LocationService.new(current_customer).get_location
    service = Map::Factory.new_service_adaptor(:distance_matrix).new(from: customer_location, to: {long: params[:long], lat: params[:lat]})
    distance_matrix = service.execute[0]["elements"][0]
    render json: distance_matrix
  end

  def locate_near_drivers
    customer_location = Customers::LocationService.new(current_customer).get_location
    drivers_information = Drivers::LocationService.get_drivers_locations_within(params[:distance], customer_location)
    drivers_locations = drivers_information.select{|driver_info| !driver_info[:driver].in_a_trip?}.map{|driver_info| driver_info[:location]}
    
    drivers_distance_matrices = Map::Factory.new_service_adaptor(:distance_matrix).new(from: drivers_locations, to: customer_location).execute
    
    min_duration = nil
    drivers_distance_matrices.each do |elements_hash|
      distance_matrix = elements_hash["elements"][0]
      duration = distance_matrix["duration_in_traffic"]
      if min_duration.nil? || duration["value"] < min_duration["value"]
        min_duration = duration
      end
    end

    render json: {
      drivers_locations: drivers_locations,
      min_duration: min_duration
    }    
  end

end