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
      # need to override these methods because of redis limitation
      # https://redis.io/commands/geoadd
      class << self
        def latitude
          (rand * 168) - 84
        end

        def longitude
          (rand * 356) - 179
        end
      end
  end
end
