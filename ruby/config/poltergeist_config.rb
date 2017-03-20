require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.configure do |config|
  config.default_driver = :poltergeist
end
