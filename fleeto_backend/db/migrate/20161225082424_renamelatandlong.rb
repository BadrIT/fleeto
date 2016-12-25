class Renamelatandlong < ActiveRecord::Migration[5.0]
  def change
    rename_column :trip_requests, :from_lat, :from_latitude
    rename_column :trip_requests, :from_long, :from_longitude
    rename_column :trips, :from_lat, :from_latitude
    rename_column :trips, :from_long, :from_longitude
  end
end
