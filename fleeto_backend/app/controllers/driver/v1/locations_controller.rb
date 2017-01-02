class Driver::V1::LocationsController < Driver::V1::BaseController

  def set_location
    Drivers::LocationService.new(current_driver).set_location(longitude: params[:longitude], latitude: params[:latitude])
    if current_driver.in_a_trip? && current_driver.current_trip.waiting_for_driver?
      current_trip = current_driver.current_trip
      driver_location = Drivers::LocationService.new(current_driver).get_location
      customer_location = Customers::LocationService.new(current_trip.customer).get_location
      
      servicClasss = Map::Factory.new_service_adaptor(:distance_matrix)
      driver_distance_matrix = servicClasss.new(from: driver_location, to: customer_location).execute

      duration = driver_distance_matrix[0]["elements"][0]["duration_in_traffic"]
      Customers::SendArrivingDriverInfoJob.perform_later(current_trip.customer_id, current_driver.id, duration["text"])
    end
    head :no_content
  end

end