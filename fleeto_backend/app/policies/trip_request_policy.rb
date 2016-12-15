class TripRequestPolicy < ApplicationPolicy

  attr_reader :user, :trip_request

  def initialize(user, trip_request)
    @user = user
    @trip_request = trip_request
  end

  def destroy?
    trip_request.customer == user
  end

  def accept?
    # TODO only drivers that received notifications should be able to accept, mainly to
    # ensure that a far driver can't accept this trip request, so should we just check current 
    # driver distance from the customer when he accepts, or should we store a list of drivers which 
    # have received notification requests ?
    trip_request.pending?
  end
end
