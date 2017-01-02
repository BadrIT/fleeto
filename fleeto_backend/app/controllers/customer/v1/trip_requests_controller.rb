class Customer::V1::TripRequestsController < Customer::V1::BaseController

  before_action :set_trip_request, only: [:cancel]

  def create
    customer_location = Customers::LocationService.new(current_customer).get_location
    @trip_request = Customers::TripRequests::CreateService.new(current_customer, trip_request_params.merge(from_latitude: customer_location[:latitude], from_longitude: customer_location[:longitude])).execute
    if @trip_request.persisted?
      Customers::TripRequests::SendToNearDriversService.new(@trip_request).execute
      render json: "Trip request created succesfully", status: :created
    else
      render json: @trip_request.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  def cancel
    authorize @trip_request
    Customers::TripRequests::CancelService.new(@trip_request).execute
    head :no_content
  end

  private

  def set_trip_request
    @trip_request = TripRequest.find(params[:id])
  end

  def trip_request_params
    params[:trip_request].permit(:to_latitude, :to_longitude)
  end
end