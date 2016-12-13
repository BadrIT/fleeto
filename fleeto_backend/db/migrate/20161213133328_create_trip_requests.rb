class CreateTripRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :trip_requests do |t|
      t.belongs_to :customer, index: true
      t.float :from_lat
      t.float :from_long
      t.float :to_lat
      t.float :to_long

      t.timestamps
    end
  end
end
