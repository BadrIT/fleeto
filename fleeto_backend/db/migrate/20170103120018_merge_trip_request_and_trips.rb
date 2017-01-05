class MergeTripAndTrips < ActiveRecord::Migration[5.0]
  def change
    remove_index :trips, :trip_request_id
    drop_table :trip_requests
    drop_table :drivers_trip_requests

    create_table :drivers_trips do |t|
      t.belongs_to :trip, index: true
      t.belongs_to :driver, index: true
      
      t.timestamps
    end
  end
end
