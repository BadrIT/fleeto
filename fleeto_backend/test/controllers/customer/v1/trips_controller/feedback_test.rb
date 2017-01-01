require 'test_helper'

class Customer::V1::TripsController::FeedbackTest < ActionDispatch::IntegrationTest
  setup do
    current_customer = create(:customer, :verified)
    @headers = sign_in(current_customer)

    @completed_trip = create(:trip, customer: current_customer, status: Trip::COMPLETED)
    @ongoing_trip = create(:trip, customer: current_customer, status: Trip::ONGOING)
  end

  test 'happy path' do
    post "/customer/v1/trips/#{@completed_trip.id}/feedback", headers: @headers, params: {
      comment: "Awesome driver!",
      rating: 10,
    }

    assert_response :created
  end

  test 'bad request' do
    post "/customer/v1/trips/#{@ongoing_trip.id}/feedback", headers: @headers, params: {
      comment: "Awesome driver!",
      rating: 10,
    }

    assert_response :bad_request
  end
end