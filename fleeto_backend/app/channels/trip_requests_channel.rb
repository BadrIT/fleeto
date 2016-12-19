class TripRequestsChannel < ApplicationCable::Channel
  def subscribed
    trip_request = TripRequest.find(params[:id])
    stream_for trip_request
  end

  def unsubscribed
    stop_all_streams
  end
end
