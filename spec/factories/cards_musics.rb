FactoryBot.define do
  factory :cards_musics do
    association :card
    association :music
  end
end
