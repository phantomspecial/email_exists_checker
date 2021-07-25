class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:ses_from)
  layout 'mailer'

  def send_to_user(email)
    mail(subject: "ユーザ向け", to: email) do |format|
      format.html
    end
  end

  def send_to_office
    mail(subject: "社内向け", to: ENV['ADMIN_USER_EMAIL']) do |format|
      format.html
    end
  end

  def send_to_admin
    mail(subject: "バウンス発生", to: ENV['ADMIN_USER_EMAIL']) do |format|
      format.html
    end
  end
end
