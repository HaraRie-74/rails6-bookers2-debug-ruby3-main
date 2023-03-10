class GroupmailMailer < ApplicationMailer

# ここのインスタンス変数は、groupmail_mailer/send_mail.text.erbのviewに使用される(メール本文のview)
  # def send_mail(from,to,mail) ★本当はこれ
  def send_mail(mail)
    @mail_title=mail.mail_title
    @mail_content=mail.mail_content
    mail from: 'example@gmail.com',
         cc: 'example@gmail.com',
         subject: mail.mail_title
         # from: from.pluck(:email), ★本当はこれ?
        # cc: to.pluck(:email), ★本当はこれ?
  end
end
