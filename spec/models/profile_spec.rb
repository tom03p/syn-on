require 'rails_helper'

RSpec.describe Profile, type: :model do
  context "バリデーションチェック" do
    let(:user) { create(:user) }
    it "nicknameが存在したら登録できること" do
      profile = build(:profile, user: user)
      expect(profile).to be_valid
    end
    it "nicknameが存在しなかったら登録出来ないこと" do
      profile = build(:profile, user: user)
      profile.nickname = nil
      expect(profile).not_to be_valid
      expect(profile.errors[:nickname]).to eq [ 'を入力してください' ]
    end
    it "nicknameが30文字以内でない時登録出来ないこと" do
      profile = build(:profile, user: user)
      profile.nickname = Faker::String.random(length: 100)
      expect(profile).not_to be_valid
      expect(profile.errors[:nickname]).to eq [ 'は30文字以内で入力してください' ]
    end
  end
end
