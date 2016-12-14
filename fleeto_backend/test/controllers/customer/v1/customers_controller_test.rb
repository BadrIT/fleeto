require 'test_helper'

class Customer::V1::CustomersControllerTest < ActionDispatch::IntegrationTest

  test "should verify customer" do
    non_verified_customer = create(:customer)
    @headers = sign_in(non_verified_customer)
    post '/customer/v1/customers/verify', headers: @headers, params: {
      verification_code: non_verified_customer.verification_code
    }

    assert_response :success
    non_verified_customer.reload
    assert non_verified_customer.verified?
  end

  test "should not verify customer with wrong verification code" do
    non_verified_customer = create(:customer)
    @headers = sign_in(non_verified_customer)
    post '/customer/v1/customers/verify', headers: @headers, params: {
      verification_code: non_verified_customer.verification_code[1..-1] # wrong verification code
    }

    assert_response :unprocessable_entity
    non_verified_customer.reload
    assert_not non_verified_customer.verified?
  end

  test "should not perform actions when not verified yet" do
    # try some action
    non_verified_customer = create(:customer)
    @headers = sign_in(non_verified_customer)
    get '/customer/v1/drivers/locate_near_drivers', headers: @headers

    assert_response :unauthorized
  end
end