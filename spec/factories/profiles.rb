FactoryBot.define do
  factory :profile do
    nickname               { Faker::Name.name }
    # message                { Faker::String.random(length: 100) }
    # birthday               { Faker::Date.birthday }
    # photo                  { Faker::Avatar.image }
    # comments_to_music      { Faker::String.random(length: 100) }
    # favorite_game          { Faker::Game.title }
    # favorite_video         { Faker::Movie.title }
    # favorite_comic         { Faker::Book.title }

    association :user
  end
end
