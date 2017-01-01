FactoryGirl.define do

  factory :trip_request do

    customer
    from_latitude {Faker::Address.latitude}
    from_longitude {Faker::Address.longitude}
    status { TripRequest::PENDING}
  end
end
