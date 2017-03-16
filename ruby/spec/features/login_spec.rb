include RSpec::Expectations

describe "Login", :type => :feature do

  it "should reject invalid logins" do
    visit "/"
    find('#login-box-content') { |loginbox|
      loginbox.find(:xpath, "//input[@placeholder='Username']").set("admin")
      loginbox.find(:xpath, "//input[@placeholder='Password']").set("invalid")
      loginbox.find(:xpath, "//input[@value='Sign in']").click
    }
    
    expect(find(".alert-danger")).to have_content("Invalid credentials, please verify them and retry.")
  end
  
  it "should allow admin login with correct password" do
    visit "/"
    find('#login-box-content') { |loginbox|
      loginbox.find(:xpath, "//input[@placeholder='Username']").set(admin_credentials[:user])
      loginbox.find(:xpath, "//input[@placeholder='Password']").set(admin_credentials[:password])
      loginbox.find(:xpath, "//input[@value='Sign in']").click
    }
    
    expect(page).to have_selector(:xpath, "//a[@id='user-menu-dropdown']/descendant::span[.='Administrator']")
  end
end
