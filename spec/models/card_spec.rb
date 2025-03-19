require 'rails_helper'

RSpec.describe Card, type: :model do
  context "バリデーションチェック" do
    let(:user) { create(:user) }
    it "titleとmessageが存在すれば登録できること" do
      card = build(:card, user: user)
      expect(card).to be_valid
    end
    it "titleが存在しない状態で登録できないこと" do
      card = build(:card, user: user)
      card.title = nil
      expect(card).to be_invalid
      expect(card.errors[:title]).to eq [ 'を入力してください' ]
    end
    it "messageが存在しない状態で登録できないこと" do
      card = build(:card, user: user)
      card.message = nil
      expect(card).to be_invalid
      expect(card.errors[:message]).to eq [ 'を入力してください' ]
    end
    it "titleが60文字以内でない時登録できないこと" do
      card = build(:card, user: user)
      card.title = Faker::String.random(length: 100)
      expect(card).to be_invalid
      expect(card.errors[:title]).to eq [ 'は60文字以内で入力してください' ]
    end
    it "messageが600文字以内でない時登録できないこと" do
      card = build(:card, user: user)
      card.message = Faker::String.random(length: 1000)
      expect(card).to be_invalid
      expect(card.errors[:message]).to eq [ 'は600文字以内で入力してください' ]
    end
  end
end
