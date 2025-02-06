class CardsMusic < ApplicationRecord
  validates :card_id, presence: true
  validates :music_id, presence: true

  belongs_to :card
  belongs_to :music
end
