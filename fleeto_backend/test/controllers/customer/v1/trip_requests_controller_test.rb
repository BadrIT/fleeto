require 'test_helper'


class Customer::V1::TripRequestsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @current_customer = create(:customer, :verified)
    @headers = sign_in(@current_customer)
  end

  test "should create a trip request" do
    trip_request = build(:trip_request)

    assert_difference("TripRequest.count", 1) do
      post '/customer/v1/trip_requests', headers: @headers, params: {
        trip_request: {
          from_lat: trip_request.from_lat,
          from_long: trip_request.from_long
        }
      }
    end

    assert_response :created
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

  test "should cancel a trip request" do
    trip_request = create(:trip_request, customer: @current_customer)
    assert_difference("TripRequest.count", -1) do
      delete "/customer/v1/trip_requests/#{trip_request.id}", headers: @headers
    end
    assert_response :no_content
  end

  test "should not cancel a trip request when not authorized to" do
    # only trip request customer(owner) can cancel it
    trip_request = create(:trip_request) # creates a trip request with new customer
    assert_no_difference("TripRequest.count") do
      delete "/customer/v1/trip_requests/#{trip_request.id}", headers: @headers
    end
    assert_response :unauthorized   
  end

end