require 'test_helper'

class CustomerTripFeedbackTest < ActiveSupport::TestCase
  def setup
    @customer_trip_feedback = build(:trip).build_customer_trip_feedback
  end

  test "invalid rating" do
    INVALID_RATINGS = [-1, 11, 0.2]
    INVALID_RATINGS.each do |invalid_rating|
      @customer_trip_feedback.rating = invalid_rating

      assert_not(@customer_trip_feedback.valid?)
      assert_includes(@customer_trip_feedback.errors.keys, :rating)
    end
  end
end
