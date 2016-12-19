require 'test_helper'


class Customer::V1::TripRequestsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @current_customer = create(:customer, :verified)
    @headers = sign_in(@current_customer)
  end

  test "should create a trip request" do
    trip_request = build(:trip_request)

    available_driver = create(:driver)
    Drivers::LocationService.new(available_driver).set_location(long: trip_request.from_long, lat: trip_request.from_lat)

    driver_in_a_trip = create(:driver)
    trip = create(:trip, status: Trip::ONGOING, driver: driver_in_a_trip)
    Drivers::LocationService.new(driver_in_a_trip).set_location(long: trip_request.from_long, lat: trip_request.from_lat)

    driver_pending_trip_request = create(:driver)
    pending_trip_request = create(:trip_request)
    pending_trip_request.drivers << driver_pending_trip_request
    Drivers::LocationService.new(driver_pending_trip_request).set_location(long: trip_request.from_long, lat: trip_request.from_lat)


    assert_difference("TripRequest.count", 1) do
      perform_enqueued_jobs do # to send request to drivers
        post '/customer/v1/trip_requests', headers: @headers, params: {
          trip_request: {
            from_lat: trip_request.from_lat,
            from_long: trip_request.from_long
          }
        }
      end
    end

    assert_response :created

    trip_request = assigns(:trip_request)
    drivers_who_received_trip_request = trip_request.drivers
    
    assert drivers_who_received_trip_request.count == 1
    assert drivers_who_received_trip_request.first == available_driver
  end

  test "should not create a trip request without mandatory fields" do
    trip_request = build(:trip_request)

    assert_difference("TripRequest.count", 0) do
      post '/customer/v1/trip_requests', headers: @headers, params: {
        trip_request: {
          dummy_params: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should not create a trip request when the customer is in another trip" do
    create(:trip, customer: @current_customer, status: Trip::WAITING_FOR_DRIVER)

    trip_request = build(:trip_request)
    assert_difference("TripRequest.count", 0) do
      post '/customer/v1/trip_requests', headers: @headers, params: {
        trip_request: {
          from_lat: trip_request.from_lat,
          from_long: trip_request.from_long
        }
      }
    end

    assert_response :unprocessable_entity 
  end

  test "should cancel a trip request" do
    trip_request = create(:trip_request, customer: @current_customer)
    perform_enqueued_jobs do 
      post "/customer/v1/trip_requests/#{trip_request.id}/cancel", headers: @headers
    end
    
    trip_request.reload
    assert trip_request.canceled?
    assert_response :no_content
  end

  test "should not cancel a trip request when not authorized to" do
    # only trip request customer(owner) can cancel it
    trip_request = create(:trip_request) # creates a trip request with new customer
    old_status = trip_request.status
    post "/customer/v1/trip_requests/#{trip_request.id}/cancel", headers: @headers
    trip_request.reload  

    assert trip_request.status == old_status
    assert_response :unauthorized 
  end

end