include RSpec::Expectations

describe "Login", :type => :feature do
  include_examples "start_with_clean_session"

  it "should reject invalid logins" do
    visit "/"
    within('div#login-box') {
      fill_in("Username", with: "admin")
      fill_in("Password", with: "invalid")
      click_on "Sign in"
    }

    expect(find(".alert-danger")).to have_content("Invalid credentials, please verify them and retry.")
  end

  it "should allow admin login with correct password" do
    visit "/"
    within('div#login-box') {
      fill_in("Username", with: admin_credentials[:user])
      fill_in("Password", with: admin_credentials[:password])
      click_on "Sign in"
    }

    expect(page).to have_selector(:xpath, "//a[@id='user-menu-dropdown']/descendant::span[.='Administrator']")
  end
end
