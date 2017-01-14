class Driver::V1::TripsController < Driver::V1::BaseController
  before_action :set_trip, only: [:show, :feedback]

  def show
    render json: @trip, serializer: Driver::TripSerializer
  end

  def index
    render json: current_user.trips, each_serializer: Driver::TripSerializer
  end

  def feedback
    @trip.create_driver_feedback(params[:comment], params[:rating])
    render json: {}, status: :created

  rescue ActiveModel::ValidationError, Trip::FeedbackError  => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:id])
  end
end
