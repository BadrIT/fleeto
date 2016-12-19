require 'test_helper'

class Drivers::V1::TripRequestsController < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  setup do
    @current_driver = create(:driver)
    @headers = sign_in(@current_driver)
  end  

  test "should accept a trip request" do
    trip_request = create(:trip_request, status: TripRequest::PENDING)
    trip_request.drivers << @current_driver

    assert_difference("Trip.count", 1) do
      perform_enqueued_jobs do
        post "/driver/v1/trip_requests/#{trip_request.id}/accept", headers: @headers
      end
    end

    assert_response :success

    trip_request.reload
    assert trip_request.accepted?

    trip = trip_request.trip
    assert trip.waiting_for_driver?
    assert trip.driver == @current_driver
  end

  test "should not accept a trip request if it is not pending" do
    
  end

  test "should not accept a trip request if it was not sent to current driver" do
    trip_request = create(:trip_request, status: TripRequest::PENDING)
    
    assert_difference("Trip.count", 0) do
      post "/driver/v1/trip_requests/#{trip_request.id}/accept", headers: @headers
    end

    assert_response :unauthorized

    trip_request.reload
    assert trip_request.pending?

  end
end