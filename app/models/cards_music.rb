class CardsMusic < ApplicationRecord
  validates :card_id, presence: true
  validates :music_id, presence: true

  belongs_to :cards
  belongs_to :musics
end
