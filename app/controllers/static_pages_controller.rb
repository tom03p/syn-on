class StaticPagesController < ApplicationController
  before_action :authenticate_user!, except: [ :start ]
  def start; end
  def setting; end
end
