Devise.setup do |config|
  
  config.navigational_formats = [:json]
  config.password_length = 4..128
end