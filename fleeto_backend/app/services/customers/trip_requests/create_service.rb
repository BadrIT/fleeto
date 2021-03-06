class Customers::TripRequests::CreateService

  attr_accessor :customer, :params

  def initialize(customer, params)
    @customer = customer
    @params = params
  end
  
  def execute
    trip_request = TripRequest.create(params.merge(customer: customer))
    trip_request
  end
  
end