class Driver < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :trips
  has_and_belongs_to_many :trips_notified_about, class_name: "Trip"

  def current_trip
    trips.where.not(status: Trip::COMPLETED).first
  end

  def in_a_trip?
    trips.where.not(status: Trip::COMPLETED).any? # better not to use current trip as it will load the trip object
  end

  def has_pending_trip?
    trips_notified_about.any?
  end

  def available?
    # a driver may have only one pending trip request at a time
    !(in_a_trip? || has_pending_trip?)
  end

end
