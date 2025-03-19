require 'rails_helper'

RSpec.describe User, type: :model do
  context "バリデーションチェック" do
    it "email、passwordとpassword_confirmationが存在すれば登録できること" do
      user = build(:user)
      expect(user).to be_valid
    end
    it "emailが存在しない状態で登録できないこと" do
      user = build(:user)
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to eq [ 'を入力してください' ]
    end
    it "emailがユニークでない状態で登録出来ないこと" do
      user1 = create(:user)
      user2 = build(:user)
      user2.email = user1.email
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to eq [ 'はすでに存在します' ]
    end
    it "passwordとpassword_confirmationが存在しない状態で登録できないこと" do
      user = build(:user)
      user.password = nil
      user.password_confirmation = nil
      expect(user).not_to be_valid
      expect(user.errors[:password]).to eq [ 'を入力してください' ]
    end
    it "passwordとpassword_confirmationが異なる状態で登録できないこと" do
      user = build(:user)
      user.password_confirmation = "yamyam3"
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to eq [ 'とパスワードの入力が一致しません' ]
    end
    it "passwordとpassword_confirmationが6文字以下で登録できないこと" do
      user = build(:user)
      user.password = 123
      user.password_confirmation = 123
      expect(user).not_to be_valid
      expect(user.errors[:password]).to eq [ 'は6文字以上で入力してください' ]
    end
  end
end
