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

  end 

end