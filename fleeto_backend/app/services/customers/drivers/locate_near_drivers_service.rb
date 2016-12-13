module Customers
  module Drivers
    class LocateNearDriversService

      attr_accessor :customer

      def initialize(customer)
        @customer = customer
      end     

      def execute
        # TODO
        Driver.all.limit(10)
      end

    end
  end
end