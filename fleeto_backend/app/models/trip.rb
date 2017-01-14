class Trip < ApplicationRecord
  belongs_to :customer
  belongs_to :driver
  belongs_to :trip_request
  has_one :customer_trip_feedback
  has_one :driver_trip_feedback

  WAITING_FOR_DRIVER, ONGOING, COMPLETED = STATUSES = %w(waiting_for_driver ongoing completed)
  enum_string :status, STATUSES

  validates :status, inclusion: STATUSES

  FeedbackError = Class.new(StandardError)

  def create_customer_feedback(comment, rating)
    raise(FeedbackError, "Only one customer feedback is allowed") if customer_trip_feedback.try(:persisted?)
    raise(FeedbackError, "Can't give a feedback for non completed trip") unless completed?

    create_customer_trip_feedback!(comment: comment, rating: rating)
  end

  def create_driver_feedback(comment, rating)
    raise(FeedbackError, "Only one driver feedback is allowed") if driver_trip_feedback.try(:persisted?)
    raise(FeedbackError, "Can't give a feedback for non completed trip") unless completed?

    create_driver_trip_feedback!(comment: comment, rating: rating)
  end
end
