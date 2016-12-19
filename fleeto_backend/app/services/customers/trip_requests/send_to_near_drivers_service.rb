class Customers::TripRequests::SendToNearDriversService

  attr_accessor :trip_request

  def initialize(trip_request)
    @trip_request = trip_request
  end

  def execute
    from_location = {
      long: @trip_request.from_long,
      lat: @trip_request.from_lat
    }
    drivers_information = Drivers::LocationService.get_drivers_locations_within(TripRequest::DISTANCE_IN_KM_TO_SEARCH_DRIVERS_WITHIN, from_location)
    drivers = drivers_information.select{|driver_info| driver_info[:driver].available?}.map{|driver_info| driver_info[:driver]}
    drivers.each do |driver|
      @trip_request.drivers << driver
      Drivers::SendTripRequestEventJob.perform_later(driver.id, @trip_request.id, "trip_request_created")
    end
  end

end

