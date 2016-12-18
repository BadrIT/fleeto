class AddStatusToTripRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :trip_requests, :status, :string
  end
end
