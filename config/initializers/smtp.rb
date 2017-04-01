if !Rails.env.test? && ENV.key?('CUBECOMP_SMTP_ADDRESS')
  Rails.application.config.action_mailer.delivery_method = :smtp

  Rails.application.config.action_mailer.smtp_settings = {
    address: ENV.fetch('CUBECOMP_SMTP_ADDRESS'),
    port: 587,
    domain: 'cubecomp.de',
    user_name: ENV.fetch('CUBECOMP_SMTP_USER'),
    password: ENV.fetch('CUBECOMP_SMTP_PASSWORD'),
    authentication: 'plain',
    enable_starttls_auto: true
  }
end
