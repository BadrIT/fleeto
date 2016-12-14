FactoryGirl.define do

  factory :customer do

    email { Faker::Internet.email }
    password {Faker::Internet.password}
    name { Faker::Name.name }
    mobile {Faker::PhoneNumber.cell_phone}

    trait :verified do
      is_verified true
    end

  end
end
