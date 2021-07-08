FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    nickname { Faker::Name.first_name }
  end
end
