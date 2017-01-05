class Customers::SendArrivingDriverInfoJob < ApplicationJob
  queue_as :drivers_trips

  def perform(customer_id, driver_id, arriving_duration)
    customer = Customer.find(customer_id)
    driver = Driver.find(driver_id)
    driver_location = Drivers::LocationService.new(driver).get_location

    CustomersChannel.broadcast_to(customer, {
      key: "arriving_driver_location_changed",
      data: {
        driver_location: driver_location,
        arriving_duration: arriving_duration
      }
    })
  end

end
