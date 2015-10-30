require File.dirname(__FILE__) + '/../test_helper'

class TestCreateInput < Test::Unit::TestCase
  def setup
    super
    login
  end
  
  def teardown
    logout
    super
  end
  
  def test_create_input
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "System").click
    @driver.find_element(:link, "Inputs").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "input-type")).select_by(:text, "Random HTTP message generator")
    @driver.find_element(:css, "option[value=\"org.graylog2.inputs.random.FakeHttpMessageInput\"]").click
    @driver.find_element(:id, "configure-input").click
    @driver.find_element(:id, "title-org.graylog2.inputs.random.FakeHttpMessageInput").clear
    @driver.find_element(:id, "title-org.graylog2.inputs.random.FakeHttpMessageInput").send_keys "test"
    @driver.find_element(:xpath, "(//button[@data-type=\"org.graylog2.inputs.random.FakeHttpMessageInput\"])").click
    verify { assert element_present?(:css, "h3.graylog-input-title") }
  end
end
