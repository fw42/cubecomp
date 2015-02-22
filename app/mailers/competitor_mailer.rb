class CompetitorMailer < ActionMailer::Base
  def competitor_email(email)
    options = {
      from: "#{email.from_name} <#{Cubecomp::Application.config.email_from}>",
      reply_to: "#{email.from_name} <#{email.from_email}>",
      to: "#{email.to_name} <#{email.to_email}>",
      subject: email.subject,
      body: email.content,
      content_type: "text/plain"
    }

    if email.cc_email
      options[:cc] = "#{email.cc_name} <#{email.cc_email}>"
    end

    mail(options)
  end
end
