class Driver::TripSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :from_long, :from_lat, :to_long, :to_lat, :started_at, :ended_at, :status
end