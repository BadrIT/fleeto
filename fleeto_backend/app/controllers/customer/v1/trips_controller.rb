class Customer::V1::TripsController < Customer::V1::BaseController
  before_action :set_trip, only: [:show, :feedback]

  def show
    render json: @trip, serializer: Customer::TripSerializer
  end

  def index
    render json: current_user.trips, each_serializer: Customer::TripSerializer
  end

  def feedback
    @trip.create_customer_feedback(params[:comment], params[:rating])
    render json: {}, status: :created

  rescue ActiveModel::ValidationError, Trip::FeedbackError  => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def set_trip
    @trip = current_user.trips.find(params[:id])
  end
end