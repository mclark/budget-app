
Airbrake.configure do |config|
  config.api_key = Figaro.env.errbit_api_key
  config.host    = Figaro.env.errbit_host
  config.port    = 80
  config.secure  = false
end