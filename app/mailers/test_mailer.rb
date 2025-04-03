class TestMailer < ApplicationMailer
  def test_email
    mail(
      to: "otomo3.p@outlook.jp",
      from: "info@syn-on.com",
      subject: "【テスト】Mailjetから送信確認"
    ) do |format|
      format.text { render plain: "これはテストメールです" }
    end
  end
end
