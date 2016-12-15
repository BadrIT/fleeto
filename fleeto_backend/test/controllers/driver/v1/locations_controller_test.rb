require 'test_helper'

class Drivers::V1::LocationsControllerTest < ActionDispatch::IntegrationTest

  def random_location
    {
      long: [-179, 179].sample, 
      lat: [-84, 84].sample
    }
  end

  setup do
    @current_driver = create(:driver)
    @driver_location = random_location
    Drivers::LocationService.new(@current_driver).set_location(@driver_location)
    @headers = sign_in(@current_driver)
  end

  teardown do
    clear_stored_locations
  end

  test "should set location" do
    location = random_location
    post '/driver/v1/locations/set_location', headers: @headers, params: location
    assert_response :success
    fetched_location = Drivers::LocationService.new(@current_driver).get_location
    # stored location is not exact, so we use approximation
    [:long, :lat].each do |coord|
      assert (location[coord] - fetched_location[coord].to_f).abs < 0.1
    end
  end


end