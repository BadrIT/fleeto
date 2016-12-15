class TripRequest < ApplicationRecord
  belongs_to :customer

  validates :from_lat, :from_long, presence: true

  validate :customer_is_not_in_a_trip


  private

  def customer_is_not_in_a_trip
    if self.customer.current_trip
      self.errors.add(:base, "Can't requset a trip when still in another trip")
    end
  end
end
