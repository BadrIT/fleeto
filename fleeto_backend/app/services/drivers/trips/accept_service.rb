class Drivers::Trips::AcceptService
    
  attr_accessor :driver, :trip

  def initialize(driver, trip)
    @driver = driver
    @trip = trip
  end

  def execute
    @trip.update(status: Trip::WAITING_FOR_DRIVER_ARRIVAL, driver: @driver)

    notify_other_drivers
    notify_customer
  end
  
  private

  def notify_other_drivers
    @trip.notified_drivers.where.not(id: driver.id).each do |driver|
      Drivers::SendTripEventJob.perform_later(driver.id, trip.id, "trip_accepted")
    end
  end

  def notify_customer
    customer = trip.customer
    Customers::SendTripEventJob.perform_later(customer.id, trip.id, "trip_accepted")
  end
end