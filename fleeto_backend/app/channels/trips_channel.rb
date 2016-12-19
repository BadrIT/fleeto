class TripsChannel < ApplicationCable::Channel
  def subscribed
    trip = Trip.find(params[:id])
    stream_for trip
  end

  def unsubscribed
    stop_all_streams
  end
end