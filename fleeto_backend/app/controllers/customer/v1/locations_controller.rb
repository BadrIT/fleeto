class Customer::V1::LocationsController < Customer::V1::BaseController

  def set_location
    Customers::LocationService.new(current_customer).set_location(longitude: params[:longitude], latitude: params[:latitude])
    head :no_content
  end

  def distance_matrix_to_drop_off_location
    customer_location = Customers::LocationService.new(current_customer).get_location
    serviceClass = Map::Factory.new_service_adaptor(:distance_matrix)
    service = serviceClass.new(from: customer_location, to: {longitude: params[:longitude], latitude: params[:latitude]})
    distance_matrix = service.execute[0]["elements"][0]
    render json: distance_matrix
  end

  def distance_to_arriving_driver
    trip = @current_customer.current_trip
    if trip.try(:status) == Trip::WAITING_FOR_DRIVER
      driver = trip.driver
      customer_location = Customers::LocationService.new(@current_customer).get_location
      driver_location = Drivers::LocationService.new(driver).get_location
      serviceClass = Map::Factory.new_service_adaptor(:distance_matrix)
      service = serviceClass.new(from: driver_location, to: customer_location)
      distance_matrix = service.execute[0]["elements"][0]
      render json: distance_matrix
    else
      render json: "There is no trip waiting for the driver to arrive", status: :unprocessable_entity
    end
  end

  def locate_near_drivers
    customer_location = Customers::LocationService.new(current_customer).get_location
    drivers_information = Drivers::LocationService.get_drivers_locations_within(params[:distance] || TripRequest::DISTANCE_IN_KM_TO_SEARCH_DRIVERS_WITHIN, customer_location)
    drivers_locations = drivers_information.select{|driver_info| !driver_info[:driver].in_a_trip?}.map{|driver_info| driver_info[:location]}

    servicClasss = Map::Factory.new_service_adaptor(:distance_matrix)
    drivers_distance_matrices = servicClasss.new(from: drivers_locations, to: customer_location).execute

    min_duration = drivers_distance_matrices.reduce(nil) do |min_duration, elements_hash|
      distance_matrix = elements_hash["elements"][0]
      duration = distance_matrix["duration_in_traffic"]
      if min_duration.nil? || duration["value"] < min_duration["value"]
        min_duration = duration
      end
      min_duration
    end

    render json: {
      drivers_locations: drivers_locations,
      min_duration: min_duration
    }    
  end

end