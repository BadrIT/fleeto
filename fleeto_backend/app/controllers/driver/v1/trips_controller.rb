class Driver::V1::TripsController < Driver::V1::BaseController
  before_action :set_trip, only: [:show, :accept]

  def accept
    authorize @trip
    Drivers::Trips::AcceptService.new(@current_driver, @trip).execute
    head :no_content
  end

  def show
    authorize @trip
    render json: @trip, serializer: Driver::TripSerializer
  end

  def index
    render json: current_user.trips, each_serializer: Driver::TripSerializer
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end
end
