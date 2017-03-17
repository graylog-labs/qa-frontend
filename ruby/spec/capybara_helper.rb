require "json"
require "selenium-webdriver"
require "rspec"
require 'capybara/rspec'
require "rest-client"
require "json"

def app_host
  ENV['APP_HOST'] || 'http://localhost:8080'
end

def api_host
  ENV['API_HOST'] || 'http://localhost:9000/api'
end

def admin_credentials
  { user: ENV['ADMIN_USER'] || 'admin', password: ENV['ADMIN_PASSWORD'] || 'admin' }
end

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = app_host
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome
  )
end

module SessionHelpers
  def register_session(username, password, host = "capybara")
    payload = { username: username, password: password, host: "capybara" }
    response = RestClient.post(api_host + "/system/sessions", payload.to_json, { content_type: :json, accept: :json })
    return JSON.parse(response)
  end

  def login_with_valid_session(user, sessionId)
    setSession = %Q[localStorage.setItem('sessionId', "\\"#{sessionId}\\"")]
    setUsername = %Q[localStorage.setItem('username', "\\"#{user}\\"")]
    page.evaluate_script(setUsername)
    page.evaluate_script(setSession)
  end
end
  