ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'simplecov'
SimpleCov.start

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...
end


class ActionDispatch::IntegrationTest
  include FactoryGirl::Syntax::Methods

  def sign_in(user)
    post '/customer/v1/auth/sign_in', params: { 
      "email"    => user.email,
      "password" => user.password
    }

    response.headers.slice("access-token", "token-type", "client", "expiry", "uid")
  end

end