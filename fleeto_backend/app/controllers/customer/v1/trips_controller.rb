class Customer::V1::TripsController < Customer::V1::BaseController
  before_action :set_trip, only: [:show, :feedback]

  def create
    customer_location = Customers::LocationService.new(current_customer).get_location
    @trip = Customers::Trips::CreateService.new(current_customer, trip_params.merge(from_latitude: customer_location[:latitude], from_longitude: customer_location[:longitude])).execute
    if @trip.persisted?
      Customers::Trips::SendToNearDriversService.new(@trip).execute
      render json: "Trip created succesfully", status: :created
    else
      render json: @trip.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def show
    authorize @trip
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
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params[:trip].permit(:to_latitude, :to_longitude)
  end
end