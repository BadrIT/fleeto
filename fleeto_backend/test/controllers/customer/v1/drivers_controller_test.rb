require 'test_helper'

class Customer::V1::DriversControllerTest < ActionDispatch::IntegrationTest

  def random_location
    {
      long: [-179, 179].sample, 
      lat: [-84, 84].sample
    }
  end

  setup do
    @current_customer = create(:customer, :verified)
    @customer_location = random_location
    Customers::LocationService.new(@current_customer).set_location(@customer_location)
    @headers = sign_in(@current_customer)
  end

  teardown do
    clear_stored_locations
  end

  test "should locate near drivers" do
    drivers = create_list(:driver, 3)
    drivers[1..-1].each{|driver| Drivers::LocationService.new(driver).set_location(random_location)}
    
    Drivers::LocationService.new(drivers[0]).set_location(@customer_location)
    
    get '/customer/v1/drivers/locate_near_drivers', headers: @headers, params: {
      distance: 100
    }

    drivers_locations = assigns(:drivers_locations)
    assert drivers_locations.present?
    assert_response :success
  end

end