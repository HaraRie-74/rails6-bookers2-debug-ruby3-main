class GroupmailMailer < ApplicationMailer

# ここのインスタンス変数は、groupmail_mailer/send_mail.text.erbのviewに使用される(メール本文のview)
  def send_mail(from,to,mail)
    @mail_title=mail.mail_title
    @mail_content=mail.mail_content
    mail from: from.pluck(:email)
         cc: to.pluck(:email)
         subject: mail.pluck(:mail_title)
  end
end
