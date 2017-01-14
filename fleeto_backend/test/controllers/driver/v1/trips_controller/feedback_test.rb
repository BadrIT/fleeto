require 'test_helper'

class Driver::V1::TripsController::FeedbackTest < ActionDispatch::IntegrationTest
  setup do
    current_driver = create(:driver)
    @headers = sign_in(current_driver)

    @completed_trip = create(:trip, driver: current_driver, status: Trip::COMPLETED)
    @ongoing_trip = create(:trip, driver: current_driver, status: Trip::ONGOING)
  end

  test 'happy path' do
    post "/driver/v1/trips/#{@completed_trip.id}/feedback", headers: @headers, params: {
      comment: "Awesome customer!",
      rating: 10,
    }

    assert_response :created
  end

  test 'bad request' do
    post "/driver/v1/trips/#{@ongoing_trip.id}/feedback", headers: @headers, params: {
      comment: "Awesome customer!",
      rating: 10,
    }

    assert_response :bad_request
  end
end