require 'rails_helper'

RSpec.describe Music, type: :model do
  context "バリデーションチェック" do
    it "linkにyoutubeの動画リンクが存在すれば登録できること" do
      music = build(:music)
      expect(music). to be_valid
    end
    it "linkが存在しない状態で登録できないこと" do
      music = build(:music)
      music.link = nil
      expect(music). to be_invalid
      expect(music.errors[:link]). to eq [ 'を入力してください', 'はYoutubeの動画URLのみ登録できます(埋め込みURL、ショートURLは不可です)' ]
    end
    it "linkにユニークでないリンクは登録されないこと" do
      music1 = create(:music)
      music2 = build(:music)
      expect(music2).to be_invalid
      expect(music2.errors[:link]). to eq [ 'はすでに存在します' ]
    end
    it "linkにyoutube以外のリンク以外が貼られたとき登録できないこと" do
      music = build(:music)
      music.link = "https://github.com/"
      expect(music).to be_invalid
      expect(music.errors[:link]). to eq [ 'はYoutubeの動画URLのみ登録できます(埋め込みURL、ショートURLは不可です)' ]
    end
    it "linkにyoutubeの埋め込みリンクが貼られても登録できないこと" do
      music = build(:music)
      music.link = "https://www.youtube.com/embed/Ez0WVxobsRo?si=VTr-lxJip4A5LYfb"
      expect(music).to be_invalid
      expect(music.errors[:link]). to eq [ 'はYoutubeの動画URLのみ登録できます(埋め込みURL、ショートURLは不可です)' ]
    end
    it "linkにyoutubeの再生リストのリンクが貼られても登録できないこと" do
      music = build(:music)
      music.link = "https://youtube.com/playlist?list=PLhswQ8T1F1qXDnbtdcnZSIUyVutuy4SAV&si=65MBLdbwIuzrqor5"
      expect(music).to be_invalid
      expect(music.errors[:link]). to eq [ 'はYoutubeの動画URLのみ登録できます(埋め込みURL、ショートURLは不可です)' ]
    end
    it "linkにyoutubeのショート動画のリンクが貼られても登録できないこと" do
      music = build(:music)
      music.link = "https://youtube.com/shorts/Wx6g7LpdRqE?si=0EA6yhPPDJ0AWWVW"
      expect(music).to be_invalid
      expect(music.errors[:link]). to eq [ 'はYoutubeの動画URLのみ登録できます(埋め込みURL、ショートURLは不可です)' ]
    end
    it "linkにyoutubeのチャンネルのリンクが貼られても登録できないこと" do
      music = build(:music)
      music.link = "https://youtube.com/channel/UCdMubEo0T0ySQS4AoGDoQcw?si=6Y3dAGWDHqzw35Mi"
      expect(music).to be_invalid
      expect(music.errors[:link]). to eq [ 'はYoutubeの動画URLのみ登録できます(埋め込みURL、ショートURLは不可です)' ]
    end
  end
end
