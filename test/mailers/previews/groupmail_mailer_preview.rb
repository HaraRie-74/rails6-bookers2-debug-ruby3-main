# Preview all emails at http://localhost:3000/rails/mailers/groupmail_mailer
class GroupmailMailerPreview < ActionMailer::Preview
  def groupmail
    mail=GroupMail.new(mail_title:"侍　太郎",mail_content:"問い合わせメッセージ")

    GroupmailMailer.send_mail(mail)
  end

end
