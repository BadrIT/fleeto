class TripRequest < ApplicationRecord
  belongs_to :customer

  validates :from_lat, :from_long, presence: true
end
