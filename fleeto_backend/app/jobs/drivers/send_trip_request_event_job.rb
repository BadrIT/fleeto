class Drivers::SendTripRequestEventJob < ApplicationJob
  queue_as :drivers_trip_requests

  def perform(driver_id, trip_request_id, event)
    driver = Driver.find(driver_id)
    trip_request = TripRequest.find(trip_request_id)
    DriversChannel.broadcast_to(driver, {
      key: event,
      data: trip_request.as_json(only: [:id, :from_lat, :from_long, :to_lat, :to_long, :status])
    })
  end

end
