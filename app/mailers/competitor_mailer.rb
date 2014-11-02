class CompetitorMailer < ActionMailer::Base
  def competitor_email(email)
    mail(
      from: "#{email.from_name} <#{email.from_email}>",
      to: "#{email.to_name} <#{email.to_email}>",
      subject: email.subject,
      body: email.content,
      content_type: "text/plain"
    )
  end
end
