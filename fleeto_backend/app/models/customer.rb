class Customer < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
          #:confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  def generate_verification_code!
    self.update_columns(verification_code: SecureRandom.hex[0...5])
  end


  def token_validation_response
    CustomerSerializer.new(self, root: "User").as_json
  end

end
