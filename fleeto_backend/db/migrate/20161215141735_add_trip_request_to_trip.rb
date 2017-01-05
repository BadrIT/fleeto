class AddTripToTrip < ActiveRecord::Migration[5.0]
  def change
    add_reference :trips, :trip_request, index: true
  end
end
