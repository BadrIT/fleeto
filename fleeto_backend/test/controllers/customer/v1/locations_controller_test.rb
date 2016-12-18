require 'test_helper'

class Customer::V1::LocationsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @current_customer = create(:customer, :verified)
    @headers = sign_in(@current_customer)
  end

  teardown do
    clear_stored_locations
  end

  test "should set location" do
    location = random_location
    post '/customer/v1/locations/set_location', headers: @headers, params: location
    assert_response :success
    fetched_location = Customers::LocationService.new(@current_customer).get_location
    # stored location is not exact, so we use approximation
    [:long, :lat].each do |coord|
      assert (location[coord] - fetched_location[coord].to_f).abs < 0.1
    end
  end

  test "should locate near drivers" do

    @customer_location = random_location
    Customers::LocationService.new(@current_customer).set_location(@customer_location)

    drivers = create_list(:driver, 3)
    drivers[1..-1].each{|driver| Drivers::LocationService.new(driver).set_location(random_location)}
    
    # setting a location within 0.01 difference in lat and long, the distance should be less than 5 KM
    near_driver_location = {
      lat: @customer_location[:lat] + 0.01,
      long: @customer_location[:long] + 0.01
    }

    Drivers::LocationService.new(drivers[0]).set_location(near_driver_location)
    
    get '/customer/v1/locations/locate_near_drivers', headers: @headers, params: {
      distance: 10
    }

    res = JSON.parse(response.body)
    assert res["min_duration"]["value"].present?
    assert res["min_duration"]["text"].present?
    assert res["drivers_locations"].present?
    assert_response :success
  end

end