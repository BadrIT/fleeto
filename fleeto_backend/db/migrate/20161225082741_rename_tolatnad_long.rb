class RenameTolatnadLong < ActiveRecord::Migration[5.0]
  def change
    rename_column :trip_requests, :to_lat, :to_latitude
    rename_column :trip_requests, :to_long, :to_longitude
    rename_column :trips, :to_lat, :to_latitude
    rename_column :trips, :to_long, :to_longitude
  end
end
