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
    input_location = random_location
    post '/customer/v1/locations/set_location', headers: @headers, params: input_location
    assert_response :success

    # stored location is not exactly the same as input location, so we use approximation: we make sure that stored location
    # is within distance of 10 M from input location
    stored_location = Customers::LocationService.new(@current_customer).get_location
    res = Redis.new.georadius(Customers::LocationService::KEY, input_location[:longitude], input_location[:latitude], 10, :m)
    assert res[0].to_i == @current_customer.id
  end

  test "should calculate distance matrix to drop off location" do
    source_location = random_location
    Customers::LocationService.new(@current_customer).set_location(source_location)
    drop_off_location = {
      longitude: source_location[:longitude] + 0.1,
      latitude: source_location[:latitude] + 0.1,
    }
    get '/customer/v1/locations/distance_matrix_to_drop_off_location', headers: @headers, params: drop_off_location
    
    assert_response :success
    res = JSON.parse(response.body)
    assert res["distance"].present?
    assert res["duration"].present?
    assert res["duration_in_traffic"].present?
  end

  test "should calculate distance matrix from arriving driver to the customer" do
    customer_location = random_location
    Customers::LocationService.new(@current_customer).set_location(customer_location)

    trip = create(:trip, status: Trip::WAITING_FOR_DRIVER_ARRIVAL,customer: @current_customer, from_longitude: customer_location[:longitude], from_latitude: customer_location[:latitude])
    
    driver = trip.driver
    driver_location = {
      longitude: customer_location[:longitude] + 0.1,
      latitude: customer_location[:latitude] + 0.1
    }
    Drivers::LocationService.new(driver).set_location(driver_location)

    get '/customer/v1/locations/distance_to_arriving_driver', headers: @headers

    assert_response :success
    res = JSON.parse(response.body)
    assert res["distance"].present?
    assert res["duration"].present?
    assert res["duration_in_traffic"].present?
  end

  test "should not calculate the distance matrix from arriving custome when there is no current trip" do
    customer_location = random_location
    Customers::LocationService.new(@current_customer).set_location(customer_location)
    get '/customer/v1/locations/distance_to_arriving_driver', headers: @headers
    assert_response :unprocessable_entity
  end

  test "should locate near drivers" do
    @customer_location = random_location
    Customers::LocationService.new(@current_customer).set_location(@customer_location)

    drivers = create_list(:driver, 3)
    drivers[1..-1].each{|driver| Drivers::LocationService.new(driver).set_location(random_location)}
    
    # setting a location within 0.01 difference in lat and long, the distance should be less than 5 KM
    near_driver_location = {
      latitude: @customer_location[:latitude] + 0.01,
      longitude: @customer_location[:longitude] + 0.01
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