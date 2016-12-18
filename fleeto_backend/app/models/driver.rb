class Driver < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :trips

  def current_trip
    trips.where.not(status: Trip::COMPLETED).first
  end

  def in_a_trip?
    trips.where.not(status: Trip::COMPLETED).any? # better not to use current trip as it will load the trip object
  end

end
