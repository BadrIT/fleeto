class V1::Customer::BaseController < ApplicationController
  before_action :authenticate_driver!

end
