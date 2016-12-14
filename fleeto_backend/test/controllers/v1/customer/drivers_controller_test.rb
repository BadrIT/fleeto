require 'test_helper'

class V1::Customer::DriversControllerTest < ActionDispatch::IntegrationTest

  setup do
    @current_customer = create(:customer, :verified)
    @headers = sign_in(@current_customer)
  end

  test "should locate near drivers" do
    drivers = create_list(:driver, 3)
    get '/v1/customer/drivers/locate_near_drivers', headers: @headers

    drivers = assigns(:drivers)
    assert drivers.present?
    assert_response :success
  end

end