class V1::Customer::TripRequestsController < BaseController

  before_action :set_trip_request, only: [:destroy]

  def create
    @trip_request = TripRequest.new(trip_request_params.merge(customer: current_customer))
    if @trip_request.save
      render json: "Trip request created succesfully", status: :created
    else
      render json: @trip_request.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @trip_request
    @trip_request.destroy
    head :no_content
  end

  private

  def set_trip_request
    @trip_request = TripRequest.find(params[:id])
  end

  def trip_request_params
    params.require(:trip_request).permit(:from_lat, :from_long, :to_lat, :to_long)
  end
end