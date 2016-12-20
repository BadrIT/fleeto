class Driver::V1::TripsController < Driver::V1::BaseController
  before_action :set_trip, only: [:show]

  def show
    render json: @trip, serializer: DriverTripSerializer
  end

  def index
    render json: current_user.trips, each_serializer: DriverTripSerializer
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:id])
  end
end