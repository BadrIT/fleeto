require 'test_helper'

class Driver::V1::LocationsControllerTest < ActionDispatch::IntegrationTest

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

    input_location = random_location
    post '/driver/v1/locations/set_location', headers: @headers, params: input_location
    assert_response :success

    # stored location is not exactly the same as input location, so we use approximation: we make sure that stored location
    # is within distance of 10 M from input location
    stored_location = Drivers::LocationService.new(@current_driver).get_location
    res = Redis.new.georadius(Drivers::LocationService::KEY, input_location[:longitude], input_location[:latitude], 10, :m)
    assert res[0].to_i == @current_driver.id
  end


end