class Customers::TripRequests::CancelService

  attr_accessor :customer, :trip_request

  def initialize(trip_request)
    @trip_request = trip_request
  end
  

  def execute
    @trip_request.cancel!
    # TODO send notifications to nearby drivers/clear this customer from their map
  end
  
end