require 'test_helper'

class Driver::V1::TripsControllerTest < ActionDispatch::IntegrationTest
  setup do
    current_driver = create(:driver)
    @headers = sign_in(current_driver)
    @trip = create(:trip, driver: current_driver)

    @not_my_trip = create(:trip)
  end

  test '#index' do
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

  test '#show one of my trips' do
    get "/driver/v1/trips/#{@trip.id}", headers: @headers

    assert_response :success

    # TODO: Stop repeating me!
    json_response = JSON.parse(response.body)

    assert_equal(json_response['trip']['id'], @trip.id)
  end

  test '#show some trip that is not mine' do
    get "/driver/v1/trips/#{@not_my_trip.id}", headers: @headers

    assert_response :not_found
  end
end