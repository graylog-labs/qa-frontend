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
    @selenium.open "/"
    @selenium.click "link=System"
    @selenium.click "link=Inputs"
    @selenium.wait_for_page_to_load "30000"
    @selenium.select "id=input-type", "label=Random HTTP message generator"
    @selenium.click "css=option[value=\"org.graylog2.inputs.random.FakeHttpMessageInput\"]"
    @selenium.click "id=configure-input"
    @selenium.type "id=title-org.graylog2.inputs.random.FakeHttpMessageInput", "test"
    @selenium.click "xpath=(//button[@data-type=\"org.graylog2.inputs.random.FakeHttpMessageInput\"])"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("css=h3.graylog-input-title")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end
end
