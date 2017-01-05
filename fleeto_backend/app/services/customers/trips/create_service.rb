class Customers::Trips::CreateService

  attr_accessor :customer, :params

  def initialize(customer, params)
    @customer = customer
    @params = params
  end
  
  def execute
    trip = Trip.create(params.merge(customer: customer, status: Trip::PENDING))
    trip
  end
  
end