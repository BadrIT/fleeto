ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'simplecov'
SimpleCov.start



module RedisHelper
  def clear_stored_locations
    redis = Redis.new
    redis.del Customers::LocationService::KEY 
    redis.del Drivers::LocationService::KEY
  end

  def random_location
    {
      long: Faker::Address.longitude,
      lat: Faker::Address.latitude
    }
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  include FactoryGirl::Syntax::Methods
  include RedisHelper

  # Add more helper methods to be used by all tests here...
end


class ActionDispatch::IntegrationTest
  include FactoryGirl::Syntax::Methods
  include RedisHelper

  def sign_in(user)
    post "/#{user.class.name.downcase}/v1/auth/sign_in", params: { 
      "email"    => user.email,
      "password" => user.password
    }

    response.headers.slice("access-token", "token-type", "client", "expiry", "uid")
  end

end

module Faker
  class Address
      # need to override these methods because of redis limitation, also to get real values in real towns
      # https://redis.io/commands/geoadd
      class << self
        def latitude
          30 + (rand * 2) - 1
        end

        def longitude
          30 + (rand * 2) - 1
        end
      end
  end
end

TANTA = {lat: 30.790163, long: 31}
CAIRO = {lat: 30.045691, long: 31.224296} 
ALEXANRIA = {lat: 31.229099, long: 29.954884}
DAMANHOUR = {lat: 31.036960, long: 30.457994}

CITIES = [TANTA, CAIRO, ALEXANRIA, DAMANHOUR]