class V1::Customer::BaseController < ApplicationController
  before_action :authenticate_customer!
  before_action :check_customer_is_verified!

  class NotAuthorized < Exception; end

  def check_customer_is_verified!
    raise NotAuthorized unless current_customer.verified?
  end

  rescue_from NotAuthorized do |exception|
    render json: {}, status: 401
  end

end
