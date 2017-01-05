class CreateDriversTrip < ActiveRecord::Migration[5.0]
  def change
    create_table :drivers_trip_requests do |t|
      t.belongs_to :trip_request, index: true
      t.belongs_to :driver, index: true
      
      t.timestamps
    end
  end
end
