FactoryBot.define do
  factory :user do
    email                  { Faker::Internet.unique.email }
    password               { "honma1123" }
    password_confirmation  { "honma1123" }
  end
end
