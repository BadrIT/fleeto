module Customers
  class LocationService
    
    KEY = "customers-#{Rails.env}"

    def initialize(customer)
      @customer = customer
    end

    def set_location(location)
      Redis.new.geoadd KEY, location[:longitude], location[:latitude], @customer.id
    end

    def get_location
      long, lat = Redis.new.geopos(KEY, @customer.id)[0]
      {
        longitude: long.to_f,
        latitude: lat.to_f
      }
    end

  end
end