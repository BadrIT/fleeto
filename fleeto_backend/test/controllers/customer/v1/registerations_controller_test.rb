require 'test_helper'

class Customer::V1::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "should register successfully" do
    customer = build(:customer)

    assert_difference("Customer.count", 1) do
      perform_enqueued_jobs do
        post '/customer/v1/auth', params: {
          email: customer.email,
          password: customer.password,
          password_confirmation: customer.password,
          name: customer.name,
          mobile: customer.mobile
        }
      end
    end

    customer = assigns(:resource) # the created customer

    assert customer.verification_code.present?
    assert_not customer.verified?
  end

  test "should not register with missing params" do
    customer = build(:customer)

    assert_no_difference("Customer.count") do
      post '/customer/v1/auth', params: {
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
    assert_response :unprocessable_entity

  end

  test "should update profile" do
    customer = create(:customer, :verified)
    headers = sign_in(customer)

    new_name = Faker::Name.name

    patch '/customer/v1/auth/', headers: headers, params: {
      name: new_name,
      current_password: customer.password,
    }
    assert_response :success
    assert customer.reload.name == new_name
  end
end