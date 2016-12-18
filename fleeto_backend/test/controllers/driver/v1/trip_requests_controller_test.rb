require 'test_helper'

class Drivers::V1::TripRequestsController < ActionDispatch::IntegrationTest

  setup do
    @current_driver = create(:driver)
    @headers = sign_in(@current_driver)
  end  

  test "should accept a trip request" do
    trip_request = create(:trip_request)

    assert_difference("Trip.count", 1) do
      post "/driver/v1/trip_requests/#{trip_request.id}/accept", headers: @headers
    end

    trip_request.reload

    assert_response :success
    assert trip_request.accepted?

    trip = trip_request.trip
    assert trip.waiting_for_driver?
  end

  test "should not accept a trip request if it is not pending" do
    
  end
  
end