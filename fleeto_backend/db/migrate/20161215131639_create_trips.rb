class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.belongs_to :customer, index: true
      t.belongs_to :driver, index: true
      
      t.float :from_long
      t.float :from_lat
      t.float :to_long
      t.float :to_lat

      t.datetime :started_at
      t.datetime :ended_at

      t.string :status

      t.timestamps
    end
  end
end
