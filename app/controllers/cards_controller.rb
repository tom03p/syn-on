class CardsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]

  def index
    @cards = Card.includes(cards_musics: :music, user: :profile)
  end

  def new
    @card = Card.new
    @music = Music.new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @card = current_user.cards.build(card_params)
        @card.save!

        @music = Music.find_or_create_by!(link: music_params[:link])
        @card.musics << @music unless @card.musics.exists?(@music.id)

        redirect_to cards_path, notice: "投稿されました"
      end

    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = "投稿に失敗しました: #{e.message}"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def card_params
    params.require(:card).permit(:title, :message)
  end

  def music_params
    params.require(:music).permit(:link)
  end
end
