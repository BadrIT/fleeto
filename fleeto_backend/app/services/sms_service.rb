class SmsService

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def send(message)
    puts "Sending .. #{message}"
  end

end