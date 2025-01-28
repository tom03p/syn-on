class Card < ApplicationRecord
  validates :title, presence: true, length: { maximum: 60 }
  validates :message, presence: true, length: { maximum: 600 }

  belongs_to :user
end
