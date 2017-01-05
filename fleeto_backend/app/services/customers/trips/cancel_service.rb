class Customers::Trips::CancelService

  attr_accessor :customer, :trip

  def initialize(trip)
    @trip = trip
  end
  

  def execute
    @trip.cancel!
    notify_drivers
  end
  

  private

  def notify_drivers
    @trip.drivers.each do |driver|
      Drivers::SendTripEventJob.perform_later(driver.id, trip.id, "trip_canceled")
    end
  end
end