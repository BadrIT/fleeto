class Driver::V1::TripRequestsController < Driver::V1::BaseController

  before_action :set_trip_request, only: [:accept]

  def accept
    authorize @trip_request
    Drivers::TripRequests::AcceptService.new(@current_driver, @trip_request).execute
    head :no_content
  end
  private

  def set_trip_request
    @trip_request = TripRequest.find(params[:id])
  end

end