require File.dirname(__FILE__) + '/../test_helper'

class TestCreateDashboard < Test::Unit::TestCase
  def setup
    super
    login
  end
  
  def teardown
    logout
    super
  end
  
  def test_create_dashboard
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "Dashboards").click
    @driver.find_element(:xpath, "//div[@id='react-dashboard-list-page']/div/div/div[2]/div/span/button").click
    @driver.find_element(:id, "undefined-title").send_keys "foo"
    @driver.find_element(:xpath, "(//input[@type='text'])[2]").send_keys "bar"
    @driver.find_element(:css, "button.btn.btn-primary").click
  end
end