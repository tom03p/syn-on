class CardsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @cards = Card.includes(:user)
  end
end
