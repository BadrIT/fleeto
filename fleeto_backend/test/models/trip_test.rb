require 'test_helper'

class TripTest < ActiveSupport::TestCase
  def setup
    @trip = build(:trip)
  end

  test "create_customer_feedback" do
    comment = "I'm happy with that driver"
    ratting = 7

    # Doesn't add a feedback on non-completed trip
    @trip.status = Trip::ONGOING
    assert_raise(Trip::FeedbackError) { @trip.create_customer_feedback(comment, ratting) }

    # Successfully creates a feedback
    @trip.status = Trip::COMPLETED
    assert_nothing_raised(Trip::FeedbackError) { @trip.create_customer_feedback(comment, ratting) }
    assert_not_nil(@trip.customer_trip_feedback)

    # Doesn't add multiple feedbacks on the same trip
    assert_raise(Trip::FeedbackError) { @trip.create_customer_feedback(comment, ratting) }
  end
end
