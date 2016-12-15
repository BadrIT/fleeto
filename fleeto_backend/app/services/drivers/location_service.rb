module Drivers
  class LocationService
    
    KEY = "drivers-#{Rails.env}"

    def initialize(driver)
      @driver = driver
    end

    def set_location(location)
      Redis.new.geoadd KEY, location[:long], location[:lat], @driver.id
    end

    def get_location
      long, lat = Redis.new.geopos(KEY, @driver.id)[0]
      {
        long: long,
        lat: lat
      }
    end

    class << self

      def get_drivers_locations_within(distance_in_km, from_location)
        driver_locations = Redis.new.georadius(KEY, from_location[:long], from_location[:lat], distance_in_km, :km, :WITHCOORD).map do |result|
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

end