class Trip < ApplicationRecord
  belongs_to :customer
  belongs_to :driver

  WAITING_FOR_DRIVER, ONGOING, COMPLETED = STATUSES = %w(waiting_for_driver ongoing COMPLETED)
  validates :status, inclusion: STATUSES

end
