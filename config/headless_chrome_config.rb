require 'selenium-webdriver'
require 'capybara/rspec'

Capybara.register_driver :headless_chromium do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    "chromeOptions" => {
      'binary' => ENV["CHROME_BINARY"] || "google-chrome",
      'args' => %w{headless no-sandbox disable-gpu}
    }
  )
  driver = Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: caps
  )
end

Capybara.configure do |config|
  config.default_driver = :headless_chromium
end
