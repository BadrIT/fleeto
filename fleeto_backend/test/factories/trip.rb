FactoryGirl.define do

  factory :trip do

    customer
    driver
    from_lat {Faker::Address.latitude}
    from_long {Faker::Address.longitude}
    to_lat {Faker::Address.latitude}
    to_long {Faker::Address.longitude}
    status {Trip::STATUSES.sample}

  end
end
