require "selenium-webdriver"
require 'capybara/rspec'

Capybara.configure do |config|
  config.default_driver = :selenium
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
