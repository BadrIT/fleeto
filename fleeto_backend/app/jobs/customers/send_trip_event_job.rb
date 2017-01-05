class Customers::SendTripEventJob < ApplicationJob
  queue_as :drivers_trips

  def perform(customer_id, trip_id, event)
    customer = Customer.find(customer_id)
    trip = Trip.find(trip_id)
    CustomersChannel.broadcast_to(customer, {
      key: event,
      data: trip.as_json(only: [:id, :from_latitude, :from_longitude, :to_latitude, :to_longitude, :status])
    })
  end

end
