class Profile < ApplicationRecord
  validates :nickname, presence: true, length: { maximum: 30 }
  # validates :photo, presence:true
  validates :message, length: { maximum: 400 }
  validates :comments_to_music, length: { maximum: 400 }
  validates :favorite_game, length: { maximum: 400 }
  validates :favorite_video, length: { maximum: 400 }
  validates :favorite_comic, length: { maximum: 400 }

  belongs_to :user
end
