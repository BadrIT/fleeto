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

    def get_drivers_locations_within(distance_in_km)
      customer_location = get_location
      driver_locations = Redis.new.georadius(Drivers::LocationService::KEY, customer_location[:long], customer_location[:lat], distance_in_km, :km, :WITHCOORD).map do |result|
        {
          driver: Driver.find(result[0]),
          long: result[1][0],
          lat: result[1][1]
        }
      end
      driver_locations
    end

  end
end