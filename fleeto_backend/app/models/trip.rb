class Trip < ApplicationRecord
  belongs_to :customer
  belongs_to :driver # the driver who accepted the trip

  has_and_belongs_to_many :notified_drivers, class_name: "Driver" # all drivers who received the trip request
  has_one :customer_trip_feedback

  PENDING, WAITING_FOR_DRIVER_ARRIVAL, ONGOING, COMPLETED = STATUSES = %w(pending waiting_for_driver_arrival ongoing completed)
  DISTANCE_IN_KM_TO_SEARCH_DRIVERS_WITHIN = 1000
  enum_string :status, STATUSES

  validates :status, inclusion: STATUSES
  validates :from_latitude, :from_longitude, presence: true
  validate :customer_is_not_in_a_trip, on: :create

  FeedbackError = Class.new(StandardError)

  def create_customer_feedback(comment, rating)
    raise(FeedbackError, "Only one customer feedback is allowed") if customer_trip_feedback.try(:persisted?)
    raise(FeedbackError, "Can't give a feedback for non completed trip") unless completed?

    create_customer_trip_feedback!(comment: comment, rating: rating)
  end

  private

  def customer_is_not_in_a_trip
    if self.customer.in_a_trip?
      self.errors.add(:base, "Can't requset a trip when still in another trip")
    end
  end

end
