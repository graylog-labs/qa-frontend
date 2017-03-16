require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations
require 'capybara/rspec'

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = 'http://localhost:8080' # change url
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome
  )
end

describe "Login", :type => :feature do

  it "should reject invalid logins" do
    visit "/"
    find('#login-box-content') { |loginbox|
      loginbox.find(:xpath, "//input[@placeholder='Username']").set("admin")
      loginbox.find(:xpath, "//input[@placeholder='Password']").set("invalid")
      loginbox.find(:xpath, "//input[@value='Sign in']").click
    }
    
    expect(find(".alert-danger")).to have_content("Invalid credentials, please verify them and retry.")
  end
  
  it "should allow admin login with correct password" do
    visit "/"
    find('#login-box-content') { |loginbox|
      loginbox.find(:xpath, "//input[@placeholder='Username']").set("admin")
      loginbox.find(:xpath, "//input[@placeholder='Password']").set("foobar")
      loginbox.find(:xpath, "//input[@value='Sign in']").click
    }
    
    expect(page).to have_selector(:xpath, "//a[@id='user-menu-dropdown']/descendant::span[.='Administrator']")
  end
end
