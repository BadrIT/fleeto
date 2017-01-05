require 'test_helper'

class Customer::V1::TripsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper 
  setup do
    @current_customer = create(:customer, :verified)
    @headers = sign_in(@current_customer)
  end

  test '#index' do
    trip = create(:trip, customer: @current_customer)
    not_my_trip = create(:trip)

    get '/customer/v1/trips', headers: @headers

    assert_response :success

    json_response = JSON.parse(response.body)

    assert_not_empty json_response['trips']
    assert_equal(json_response['trips'].first['id'], trip.id)

    assert_not_includes(
      json_response['trips'].map{ |trip| trip['id'] },
      not_my_trip.id
    )
  end

  test "should create a trip request" do
    trip = build(:trip)
    Customers::LocationService.new(@current_customer).set_location(longitude: trip.from_longitude, latitude: trip.from_latitude)
    available_driver = create(:driver)
    Drivers::LocationService.new(available_driver).set_location(longitude: trip.from_longitude, latitude: trip.from_latitude)

    driver_in_a_trip = create(:driver)
    trip = create(:trip, status: Trip::ONGOING, driver: driver_in_a_trip)
    Drivers::LocationService.new(driver_in_a_trip).set_location(longitude: trip.from_longitude, latitude: trip.from_latitude)

    driver_pending_trip = create(:driver)
    pending_trip = create(:trip, status: Trip::PENDING)
    pending_trip.notified_drivers << driver_pending_trip
    Drivers::LocationService.new(driver_pending_trip).set_location(longitude: trip.from_longitude, latitude: trip.from_latitude)

    assert_difference("Trip.count", 1) do
      perform_enqueued_jobs do # to send request to drivers
        post '/customer/v1/trips', headers: @headers, params: {
          trip: {
            from_latitude: trip.from_latitude,
            from_longitude: trip.from_longitude
          }
        }
      end
    end
    assert_response :created

    trip = assigns(:trip)
    assert trip.pending?

    notified_drivers = trip.notified_drivers
    
    assert notified_drivers.count == 1
    assert notified_drivers.first == available_driver
  end

  test "should not create a trip request when the customer is in another trip" do
    create(:trip, customer: @current_customer, status: Trip::WAITING_FOR_DRIVER_ARRIVAL)

    trip = build(:trip)
    assert_difference("Trip.count", 0) do
      post '/customer/v1/trips', headers: @headers, params: {
        trip: {
          from_latitude: trip.from_latitude,
          from_longitude: trip.from_longitude
        }
      }
    end

    assert_response :unprocessable_entity 
  end

  # test "should cancel a trip request" do
  #   skip
  #   trip = create(:trip, customer: @current_customer)
  #   perform_enqueued_jobs do 
  #     post "/customer/v1/trips/#{trip.id}/cancel", headers: @headers
  #   end
    
  #   trip.reload
  #   assert trip.canceled?
  #   assert_response :no_content
  # end

  # test "should not cancel a trip request when not authorized to" do
  #   skip
  #   # only trip request customer(owner) can cancel it
  #   trip = create(:trip) # creates a trip request with new customer
  #   old_status = trip.status
  #   post "/customer/v1/trips/#{trip.id}/cancel", headers: @headers
  #   trip.reload  

  #   assert trip.status == old_status
  #   assert_response :unauthorized 
  # end


  test '#show one of my trips' do
    trip = create(:trip, customer: @current_customer)

    get "/customer/v1/trips/#{trip.id}", headers: @headers

    assert_response :success

    # TODO: Stop repeating me!
    json_response = JSON.parse(response.body)

    assert_equal(json_response['trip']['id'], trip.id)
  end

  test '#show some trip that is not mine' do
    not_my_trip = create(:trip)
    get "/customer/v1/trips/#{not_my_trip.id}", headers: @headers

    assert_response :unauthorized
  end
end