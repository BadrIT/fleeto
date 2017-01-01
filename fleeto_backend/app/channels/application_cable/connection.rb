module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected
      # https://www.sitepoint.com/create-a-chat-app-with-rails-5-actioncable-and-devise/ 
      def find_verified_user # this checks whether a user is authenticated with devise
        #TODO distinguish between customer and driver
        customer = Customer.find_by(email: request.params[:uid])
        if customer && customer.valid_token?(request.params["access-token"], request.params[:client])
          verified_user = customer
        else
          reject_unauthorized_connection
        end
      end
  end
end
