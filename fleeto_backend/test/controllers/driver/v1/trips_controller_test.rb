require 'test_helper'

class Driver::V1::TripsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper 
  setup do
    @current_driver = create(:driver)
    @headers = sign_in(@current_driver)
  end

  test '#index' do
    @trip = create(:trip, driver: @current_driver)
    @not_my_trip = create(:trip)

    get '/driver/v1/trips', headers: @headers

    assert_response :success

    json_response = JSON.parse(response.body)

    assert_not_empty json_response['trips']
    assert_equal(json_response['trips'].first['id'], @trip.id)

    assert_not_includes(
      json_response['trips'].map{ |trip| trip['id'] },
      @not_my_trip.id
    )
  end

  test "should accept a trip request" do
    trip = create(:trip, status: Trip::PENDING)
    trip.notified_drivers << @current_driver
    perform_enqueued_jobs do
      post "/driver/v1/trips/#{trip.id}/accept", headers: @headers
    end

    assert_response :success

    trip.reload
    
    assert trip.waiting_for_driver_arrival?
    assert trip.driver == @current_driver
  end

  test "should not accept a trip request if it is not pending" do
    
  end

  test "should not accept a trip request if it was not sent to current driver" do
    trip = create(:trip, status: Trip::PENDING, driver: nil)
    
    post "/driver/v1/trips/#{trip.id}/accept", headers: @headers
    assert_response :unauthorized
    trip.reload
    assert trip.pending?

  end

  test '#show one of my trips' do
    @trip = create(:trip, driver: @current_driver)
    get "/driver/v1/trips/#{@trip.id}", headers: @headers

    assert_response :success

    # TODO: Stop repeating me!
    json_response = JSON.parse(response.body)

    assert_equal(json_response['trip']['id'], @trip.id)
  end

  test '#show some trip that is not mine' do
    @not_my_trip = create(:trip)
    get "/driver/v1/trips/#{@not_my_trip.id}", headers: @headers

    assert_response :unauthorized
  end
end