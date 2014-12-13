
Budget::Application.config.action_mailer.delivery_method = :smtp

Budget::Application.config.action_mailer.smtp_settings = {
  address:              "smtp.gmail.com",
  port:                 587,
  domain:               Figaro.env.domain,
  user_name:            Figaro.env.gmail_username,
  password:             Figaro.env.gmail_password,
  authentication:       'plain',
  enable_starttls_auto: true  
}

Budget::Application.config.action_mailer.default_url_options = {
  host: Figaro.env.domain
}