class Music < ApplicationRecord
  VALID_YOUTUBE_REGEX = %r{\Ahttps?://(?:www\.)?(youtube\.com/watch\?v=|youtu\.be/)([a-zA-Z0-9_-]{11})(\?.*)?\z}i
  validates :link, presence: true, uniqueness: true, format: { with: VALID_YOUTUBE_REGEX, message: "はYoutubeの動画URLのみ登録できます(埋め込みURL、ショートURLは不可です)" }

  has_many :cards_musics, dependent: :destroy
  has_many :cards, through: :cards_musics
end
