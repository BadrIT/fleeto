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
    drivers_with_location = Drivers::LocationService.get_drivers_locations_within(TripRequest::DISTANCE_IN_KM_TO_SEARCH_DRIVERS_WITHIN, from_location)
    drivers = drivers_with_location.select{|driver_with_location| !driver_with_location[:driver].in_a_trip?}.map{|driver_with_location| driver_with_location[:driver]}
    drivers.each do |driver|
      Customers::SendTripRequestToDriverJob.perform_later(@trip_request, driver)
    end
  end

end

