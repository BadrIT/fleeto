class Driver::TripSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :from_longitude, :from_latitude, :to_longitude, :to_latitude, :started_at, :ended_at, :status
end