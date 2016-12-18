class Trip < ApplicationRecord
  belongs_to :customer
  belongs_to :driver
  belongs_to :trip_request

  WAITING_FOR_DRIVER, ONGOING, COMPLETED = STATUSES = %w(waiting_for_driver ongoing COMPLETED)
  enum_string :status, STATUSES
  
  validates :status, inclusion: STATUSES

end
