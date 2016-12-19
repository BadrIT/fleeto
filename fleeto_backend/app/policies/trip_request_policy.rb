class TripRequestPolicy < ApplicationPolicy

  attr_reader :user, :trip_request

  def initialize(user, trip_request)
    @user = user
    @trip_request = trip_request
  end

  def cancel?
    trip_request.customer == user
  end

  def accept?
    driver = user
    trip_request.pending? && driver.trip_requests.where(id: trip_request.id).any?
  end
end
