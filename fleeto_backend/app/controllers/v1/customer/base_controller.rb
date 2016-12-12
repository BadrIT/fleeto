class V1::Customer::BaseController < ApplicationController
  before_action :authenticate_customer!

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

  rescue_from NotAuthorized do |exception|
    render json: {errors: "Not authorized"}
  end

end
