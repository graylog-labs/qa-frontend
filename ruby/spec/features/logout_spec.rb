include RSpec::Expectations

describe "Logout", :type => :feature do
  include_examples "authenticated"
  
  it "should logout the user" do
    visit "/"
    expect(find(:xpath, "//a[@id='user-menu-dropdown']/descendant::span[.='Administrator']"))
    find(:xpath, "//a[@id='user-menu-dropdown']/descendant::span[.='Administrator']").click
    find(:link, "Log out").click
    expect(page).to have_selector(:xpath, "//input[@placeholder='Username']")
  end
end
