require "json"
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

def driver_profile
  ENV['DRIVER_PROFILE'] || "chrome"
end

Capybara.configure do |config|
  config.run_server = false
  config.app_host = app_host
end

require "./config/#{driver_profile}_config"

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

  def clear_session
    page.evaluate_script(%Q[localStorage.setItem('sessionId', '')])
    page.evaluate_script(%Q[localStorage.setItem('username', '')])
  end
end

module GenericHelpers
  def randomName
    ('a'..'z').to_a.shuffle[0,8].join
  end
end

RSpec.shared_examples "authenticated" do |scope = :all|
  before(scope) do
    @session = register_session(admin_credentials[:user], admin_credentials[:password])
    visit '/'
    login_with_valid_session(admin_credentials[:user], @session["session_id"])
  end
end

RSpec.shared_examples "start_with_clean_session" do |scope = :all|
  before(scope) do
    visit '/'
    clear_session
  end
end
