class Customer < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  validates :name, :mobile, presence: true
  validates :mobile, uniqueness: true, if: :verified?

  has_many :trips

  def verify!
    self.update_columns(is_verified: true)
  end

  def verified?
    self.is_verified?
  end

  def generate_verification_code!
    self.update_columns(verification_code: SecureRandom.hex[0...4])
  end

  def current_trip
    trips.where.not(status: Trip::COMPLETED).first
  end

  def in_a_trip?
    trips.where.not(status: Trip::COMPLETED).any?
  end

end
