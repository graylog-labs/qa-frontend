require "test/unit"
require "selenium/client"
require "base64"

class Test::Unit::TestCase
  def setup
    if not ENV['SUT']
      raise "Define target system by setting 'SUT' environment variable"
      exit 1
    end
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => ENV['SUT'],
      :port => 4444,
      :browser => "firefox",
      :url => "http://127.0.0.1:9000/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end

  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end

  def screenshot(filename='/tmp/screenshot.png')
    screenshot = @selenium.capture_entire_page_screenshot_to_string("")
    File.open(filename, 'wb') do|f|
      f.write(Base64.decode64(screenshot))
    end
  end

  def login
    @selenium.open "/"
    @selenium.type "id=username", "admin"
    @selenium.type "id=password", "admin"
    @selenium.click "id=signin"
    @selenium.wait_for_page_to_load "30000"
  end

  def logout
    @selenium.open "/logout"
    @selenium.wait_for_page_to_load "30000"
  end
end

