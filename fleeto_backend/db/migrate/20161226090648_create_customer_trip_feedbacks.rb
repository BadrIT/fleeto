class CreateCustomerTripFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :customer_trip_feedbacks do |t|
      t.references :trip, foreign_key: true
      t.text :comment
      t.integer :rating

      t.timestamps
    end
  end
end
