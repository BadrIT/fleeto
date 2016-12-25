class Customer::V1::TripsController < Customer::V1::BaseController
  before_action :set_trip, only: [:show]

  def show
    render json: @trip, serializer: Customer::TripSerializer
  end

  def index
    render json: current_user.trips, each_serializer: Customer::TripSerializer
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:id])
  end
end