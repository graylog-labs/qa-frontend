include RSpec::Expectations

describe "Logout", :type => :feature do
  # TODO: add before task which logs in admin user, so we do not rely on the last test doing this
  it "should logout the user" do
    visit "/"
    expect(find(:xpath, "//a[@id='user-menu-dropdown']/descendant::span[.='Administrator']"))
    find(:xpath, "//a[@id='user-menu-dropdown']/descendant::span[.='Administrator']").click
    find(:link, "Log out").click
    expect(page).to have_selector(:xpath, "//input[@placeholder='Username']")
  end
end
