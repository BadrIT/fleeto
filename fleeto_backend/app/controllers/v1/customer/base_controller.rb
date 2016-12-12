class V1::Customer::BaseController < ApplicationController
  before_action :authenticate_customer!
  before_action :check_customer_is_verified!

  # quick hack, instead of having to parse the response headers for now when testing the app from postman
  class NotAuthorized < Exception
  end

  def authenticate_customer!
    customer = Customer.find_by(email: request.headers["uid"])
    if customer
      sign_in customer, store: false 
    else
      raise NotAuthorized
    end
  end

  def check_customer_is_verified
    raise NotAuthorized unless current_customer.verified?
  end

  rescue_from NotAuthorized do |exception|
    render json: {}, status: 401
  end

end
