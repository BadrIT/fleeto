module Customers
  class LocationService
    
    KEY = "customers-#{Rails.env}"

    def initialize(customer)
      @customer = customer
    end

    def set_location(location)
      Redis.new.geoadd KEY, location[:long], location[:lat], @customer.id
    end

    def get_location
      long, lat = Redis.new.geopos(KEY, @customer.id)[0]
      {
        long: long,
        lat: lat
      }
    end

  end
end