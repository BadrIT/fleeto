require 'test_helper'


class V1::Customer::RegistrationsControllerTest < ActionDispatch::IntegrationTest

  setup do
  end

  test "should register successfully" do
    customer = build(:customer)

    assert_difference("Customer.count", 1) do
      post '/v1/customer/auth', params: {
        email: customer.email,
        password: customer.password,
        password_confirmation: customer.password,
        name: customer.name,
        mobile: customer.mobile
      }
    end

    customer = assigns(:resource) # the created customer

    assert customer.verification_code.present?
    assert_not customer.verified?
  end

  test "should not register with missing params" do
    customer = build(:customer)

    assert_no_difference("Customer.count") do
      post '/v1/customer/auth', params: {
        email: nil,
        password: nil,
        password_confirmation: nil,
        name: nil,
        mobile: nil
      }
    end
    customer = assigns(:resource)

    [:email, :password, :name, :mobile].each do |field|
      assert customer.errors[field].present?
    end    
    assert response.status == 422

  end

end