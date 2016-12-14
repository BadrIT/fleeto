class Customers::TripRequests::DestroyService

  attr_accessor :customer, :trip_request

  def initialize(customer, trip_request)
    @customer = customer
    @trip_request = trip_request
  end
  

  def execute
    @trip_request.destroy
    # TODO send notifications to nearby drivers/clear this customer from their map
  end
  
end