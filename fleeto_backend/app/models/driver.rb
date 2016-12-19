class Driver < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :trips
  has_and_belongs_to_many :trip_requests

  def in_a_trip?
    trips.where.not(status: Trip::COMPLETED).first
  end

  def has_pending_trip_request?
    self.trip_requests.where(status: TripRequest::PENDING).any?
  end

  def available?
    # a driver may have only one pending trip request at a time
    !(in_a_trip? || has_pending_trip_request?)
  end

end
