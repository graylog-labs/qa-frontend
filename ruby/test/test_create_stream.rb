require File.dirname(__FILE__) + '/../test_helper'

class TestCreateStream < Test::Unit::TestCase

  def setup
    super
    login
  end
  
  def teardown
    logout
    super
  end
  
  def test_create_stream
    @driver.get(@base_url + "/")
    wait_for(:link, "Streams")
    @driver.find_element(:link, "Streams").click
    @driver.find_element(:xpath, "(//button[@type='button'])[2]").click
    @driver.find_element(:css, "input.form-control").send_keys "Title"
    @driver.find_element(:xpath, "(//input[@value=''])[2]").send_keys "Description"
    @driver.find_element(:css, "button.btn.btn-primary").click
    assert !60.times{ break if (element_present?(:link, "Title") rescue false); sleep 1 }
    verify { assert element_present?(:link, "Title") }
  end
  
end
