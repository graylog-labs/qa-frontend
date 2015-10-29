require File.dirname(__FILE__) + '/../test_helper'

class TestLoginLogout < Test::Unit::TestCase
  def test_login_logout
    @selenium.open "/"
    @selenium.type "id=username", "admin"
    @selenium.type "id=password", "admin"
    @selenium.click "id=signin"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//div[@id='navigation-bar']/nav/div/div[2]/ul[3]/li[2]/a/span"
    @selenium.click "link=Log out"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "id=username", "admin"
    @selenium.type "id=password", "admin"
    @selenium.click "id=signin"
    @selenium.wait_for_page_to_load "30000"
  end
end
