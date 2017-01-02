module Drivers
  class LocationService
    
    KEY = "drivers-#{Rails.env}"

    def initialize(driver)
      @driver = driver
    end

    def set_location(location)
      Redis.new.geoadd KEY, location[:longitude], location[:latitude], @driver.id
    end

    def get_location
      long, lat = Redis.new.geopos(KEY, @driver.id)[0]
      {
        longitude: long.to_f,
        latitude: lat.to_f
      }
    end

    class << self

      def get_drivers_locations_within(distance_in_km, from_location)
        driver_locations = Redis.new.georadius(KEY, from_location[:longitude], from_location[:latitude], distance_in_km, :km, :WITHCOORD).map do |result|
          {
            driver: Driver.find(result[0]),
            location:{
              longitude: result[1][0].to_f,
              latitude: result[1][1].to_f
            }
          }
        end
        driver_locations
      end
      
    end

  end 

end