class Customers::TripRequests::CancelService

  attr_accessor :customer, :trip_request

  def initialize(trip_request)
    @trip_request = trip_request
  end
  

  def execute
    @trip_request.cancel!
    notify_drivers
  end
  

  private

  def notify_drivers
    @trip_request.drivers.each do |driver|
      Drivers::SendTripRequestEventJob.perform_later(driver.id, trip_request.id, "trip_request_canceled")
    end
  end
end