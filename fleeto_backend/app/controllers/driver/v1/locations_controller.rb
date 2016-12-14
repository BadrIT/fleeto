class Driver::V1::LocationsController < Driver::V1::BaseController

  def set_location
    Drivers::LocationService.new(current_driver).set_location(long: params[:long], lat: params[:lat])
    head :no_content
  end

end