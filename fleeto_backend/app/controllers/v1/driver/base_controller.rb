class V1::Customer::BaseController < ApplicationController
  before_action :authenticate_driver!

  # for libraries that implicitly need current user
  def current_user
    current_driver
  end

end
