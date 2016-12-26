class Drivers::TripRequests::AcceptService
    
  attr_accessor :driver, :trip_request

  def initialize(driver, trip_request)
    @driver = driver
    @trip_request = trip_request
  end

  def execute
    @trip_request.accept!
    Trip.create!(
      customer: @trip_request.customer,
      driver: @driver,
      trip_request: @trip_request,
      from_longitude: @trip_request.from_longitude,
      from_latitude: @trip_request.from_latitude,
      status: Trip::WAITING_FOR_DRIVER
    )

    notify_other_drivers
    notify_customer
  end
  
  private

  def notify_other_drivers
    @trip_request.drivers.where.not(id: driver.id).each do |driver|
      Drivers::SendTripRequestEventJob.perform_later(driver.id, trip_request.id, "trip_request_accepted")
    end
  end

  def notify_customer
    customer = trip_request.customer
    Customers::SendTripRequestEventJob.perform_later(customer.id, trip_request.id, "trip_request_accepted")
  end
end