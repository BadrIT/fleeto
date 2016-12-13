class TripRequestPolicy < ApplicationPolicy

  attr_reader :user, :trip_request

  def initialize(user, trip_request)
    @user = user
    @trip_request = trip_request
  end

  def destroy?
    trip_request.customer == user
  end
end
