class Customer::V1::TripRequestsController < Customer::V1::BaseController

  before_action :set_trip_request, only: [:destroy]

  def create
    @trip_request = Customers::TripRequests::CreateService.new(current_customer, trip_request_params).execute
    if @trip_request.persisted?
      Customers::TripRequests::SendToNearDriversService.new(@trip_request).execute
      render json: "Trip request created succesfully", status: :created
    else
      render json: @trip_request.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @trip_request
    Customers::TripRequests::DestroyService.new(@trip_request).execute
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