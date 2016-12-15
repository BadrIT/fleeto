FactoryGirl.define do

  factory :trip_request do

    customer
    from_lat {Faker::Address.latitude}
    from_long {Faker::Address.longitude}
    status { TripRequest::PENDING}
  end
end
