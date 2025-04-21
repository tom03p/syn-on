module MailProcessingMacros
  def extract_confirmation_url(mail)
    body = mail.text_part.body.raw_source
    url = body[/http[^\s")]+/]
    url.gsub!("http://localhost:3000", Capybara.app_host)
  end
end
