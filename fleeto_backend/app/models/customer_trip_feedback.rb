class CustomerTripFeedback < ApplicationRecord
  belongs_to :trip
  validates :rating, :inclusion => 1..10
end
