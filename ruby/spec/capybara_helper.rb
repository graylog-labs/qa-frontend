require "json"
require "selenium-webdriver"
require "rspec"
require 'capybara/rspec'

def app_host
  ENV['APP_HOST'] || 'http://localhost:8080'
end

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = app_host # change url
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome
  )
end

def admin_credentials
  { user: ENV['ADMIN_USER'] || 'admin', password: ENV['ADMIN_PASSWORD'] || 'admin' }
end
