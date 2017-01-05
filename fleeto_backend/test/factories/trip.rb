FactoryGirl.define do

  factory :trip do

    customer
    driver
    from_latitude {Faker::Address.latitude}
    from_longitude {Faker::Address.longitude}
    to_latitude {Faker::Address.latitude}
    to_longitude {Faker::Address.longitude}
    status {Trip::PENDING}
  end
end
