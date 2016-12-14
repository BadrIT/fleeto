class Customer::V1::BaseController < ApplicationController
  before_action :authenticate_customer!
  before_action :check_customer_is_verified!

  def check_customer_is_verified!
    raise NotAuthorized unless current_customer.verified?
  end


  class NotAuthorized < SecurityError; end
  
  rescue_from NotAuthorized do |exception|
    head :unauthorized
  end

  # for libraries that implicitly need current user
  def current_user
    current_customer
  end

end
