class TripPolicy < ApplicationPolicy

  attr_reader :user, :trip

  def initialize(user, trip)
    @user = user
    @trip = trip
  end

  # def cancel?
  #   trip.customer == user
  # end

  def show?
    trip.customer == @user || trip.driver == @user
  end

  def accept?
    driver = @user
    trip.pending? && trip.notified_drivers.where(id: driver.id).any?
  end
end
