# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"

ActionMailer::Base.smtp_settings = {
  :address        => "smtp.mxes.net",
  :port           => 587,
  :domain         => "jerakeen.org",
  :user_name      => "tom_jerakeen.org",
  :password       => "PASSWORD",
  :authentication => :plain
}

config.action_mailer.default_url_options = { :host => "achievements.heroku.com" }
  
