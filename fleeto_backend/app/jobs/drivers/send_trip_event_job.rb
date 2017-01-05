class Drivers::SendTripEventJob < ApplicationJob
  queue_as :drivers_trips

  def perform(driver_id, trip_id, event)
    driver = Driver.find(driver_id)
    trip = Trip.find(trip_id)
    DriversChannel.broadcast_to(driver, {
      key: event,
      data: trip.as_json(only: [:id, :from_latitude, :from_longitude, :to_latitude, :to_longitude, :status])
    })
  end

end
