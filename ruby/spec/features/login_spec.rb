include RSpec::Expectations

describe "Login", :type => :feature do

  it "should reject invalid logins" do
    visit "/"
    within('div#login-box') {
      find(:xpath, "//input[@placeholder='Username']").set("admin")
      find(:xpath, "//input[@placeholder='Password']").set("invalid")
      find(:xpath, "//input[@value='Sign in']").click
    }

    expect(find(".alert-danger")).to have_content("Invalid credentials, please verify them and retry.")
  end

  it "should allow admin login with correct password" do
    visit "/"
    within('div#login-box') {
      find(:xpath, "//input[@placeholder='Username']").set(admin_credentials[:user])
      find(:xpath, "//input[@placeholder='Password']").set(admin_credentials[:password])
      find(:xpath, "//input[@value='Sign in']").click
    }

    expect(page).to have_selector(:xpath, "//a[@id='user-menu-dropdown']/descendant::span[.='Administrator']")
  end
end
