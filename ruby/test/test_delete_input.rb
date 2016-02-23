require File.dirname(__FILE__) + '/../test_helper'

class TestDeleteInput < Test::Unit::TestCase
  def setup
    super
    login
  end
  
  def teardown
    logout
    super
  end
  
  def test_delete_input
    @driver.get(@base_url + "/")
    @driver.find_element(:css, "a.dropdown-toggle > span").click
    screenshot
    wait.until { driver.find_element(:id => 'next_button').displayed? }   
    @driver.find_element(:link, "Inputs").click
    @driver.find_element(:xpath, "(//button[@type='button'])[3]").click
    @driver.find_element(:link, "Delete input").click
    assert_match /^Really delete input test[\s\S]$/, close_alert_and_get_its_text()
  end
  
end