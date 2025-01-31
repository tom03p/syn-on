class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # :confirmable, :timeoutable

  has_many :cards, dependent: :destroy
  has_one :profile, dependent: :destroy
  after_create :create_profile

  private

  def create_profile
    Profile.create(user: self, message: "このユーザーは新規登録したばかりです。")
  end
end
