require 'test_helper'

class Customer::V1::DriversControllerTest < ActionDispatch::IntegrationTest

  setup do
    @current_customer = create(:customer, :verified)
    @headers = sign_in(@current_customer)
  end

  test "should locate near drivers" do
    drivers = create_list(:driver, 3)
    get '/customer/v1/drivers/locate_near_drivers', headers: @headers

    drivers = assigns(:drivers)
    assert drivers.present?
    assert_response :success
  end

end