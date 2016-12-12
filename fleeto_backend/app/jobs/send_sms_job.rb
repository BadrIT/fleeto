class SendSmsJob < ApplicationJob
  queue_as :sms

  def perform(user, message)
    SmsService.new(user).send(message)
  end

end
