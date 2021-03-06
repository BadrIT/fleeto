class Customers::SendTripRequestEventJob < ApplicationJob
  queue_as :drivers_trip_requests

  def perform(customer_id, trip_request_id, event)
    customer = Customer.find(customer_id)
    trip_request = TripRequest.find(trip_request_id)
    CustomersChannel.broadcast_to(customer, {
      key: event,
      data: trip_request.as_json(only: [:id, :from_latitude, :from_longitude, :to_latitude, :to_longitude, :status])
    })
  end

end
