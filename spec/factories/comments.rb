FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    post { nil }
  end
end
