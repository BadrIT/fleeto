class Customers::Trips::SendToNearDriversService

  attr_accessor :trip

  def initialize(trip)
    @trip = trip
  end

  def execute
    from_location = {
      longitude: @trip.from_longitude,
      latitude: @trip.from_latitude
    }
    drivers_information = Drivers::LocationService.get_drivers_locations_within(Trip::DISTANCE_IN_KM_TO_SEARCH_DRIVERS_WITHIN, from_location)
    drivers = drivers_information.select{|driver_info| driver_info[:driver].available?}.map{|driver_info| driver_info[:driver]}
    drivers.each do |driver|
      @trip.notified_drivers << driver
      Drivers::SendTripEventJob.perform_later(driver.id, @trip.id, "trip_created")
    end
  end

end

