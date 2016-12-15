class Customers::SendTripRequestToDriverJob < ApplicationJob
  queue_as :trip_requests

  def perform(trip_request, driver)
    trip_request.send_to(driver)
  end

end
