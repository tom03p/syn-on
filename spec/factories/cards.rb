FactoryBot.define do
  factory :card do
    title      { 'てすと' } # { Faker::String.random(length: 10) }
    message    { '確認中' } # { Faker::String.random(length: 100) }

    association :user
  end
end
