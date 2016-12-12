class Customer < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  validates :name, :mobile, presence: true

  def verified?
    self.is_verified?
  end

  def generate_verification_code!
    self.update_columns(verification_code: SecureRandom.hex[0...4])
  end


  def token_validation_response
    CustomerSerializer.new(self, root: "User").as_json
  end

end
