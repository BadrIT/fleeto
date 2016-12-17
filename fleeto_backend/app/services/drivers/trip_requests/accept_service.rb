class Drivers::TripRequests::AcceptService
    
  attr_accessor :driver, :trip_request

  def initialize(driver, trip_request)
    @driver = driver
    @trip_request = trip_request
  end

  def execute
    @trip_request.update(status: TripRequest::ACCEPTED)
    Trip.create!(
      customer: @trip_request.customer,
      driver: @driver,
      trip_request: @trip_request,
      from_long: @trip_request.from_long,
      from_lat: @trip_request.from_lat,
      status: Trip::WAITING_FOR_DRIVER
    )
    # TODO send notifications to all other drivers that this trip request has been taken
    # TODO send notification to the customer that this trip request is accepted
  end
  
end