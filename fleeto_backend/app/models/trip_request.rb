class TripRequest < ApplicationRecord
  belongs_to :customer

  validates :from_lat, :from_long, presence: true

  # TODO this should be configurable from the admin
  DISTANCE_IN_KM_TO_SEARCH_DRIVERS_WITHIN = 5

  def send_to(driver)
    #TODO 
    puts "Sending trip request #{self.id} to #{driver.name}...."
  end


end
