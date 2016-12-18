class TripRequest < ApplicationRecord
  belongs_to :customer
  has_one :trip
  
  validates :from_lat, :from_long, presence: true

  validate :customer_is_not_in_a_trip

  PENDING, CANCELED, ACCEPTED, EXPIERED = STATUSES = %w(pending canceled accepted expired)
  enum_string :status, STATUSES

  # TODO this should be configurable from the admin
  DISTANCE_IN_KM_TO_SEARCH_DRIVERS_WITHIN = 5

  def send_to(driver)
    #TODO 
    puts "Sending trip request #{self.id} to #{driver.name}...."
  end

  def cancel!
    update_columns(status: CANCELED)
  end

  private

  def customer_is_not_in_a_trip
    if self.customer.current_trip
      self.errors.add(:base, "Can't requset a trip when still in another trip")
    end
  end


end
