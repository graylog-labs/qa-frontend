include RSpec::Expectations
include GenericHelpers
include SessionHelpers

describe "Creating a user", :type => :feature do

  before(:all) do
    @adminName = randomName
    @userName = randomName
    @session = register_session(admin_credentials[:user], admin_credentials[:password])
    visit '/'
    login_with_valid_session(admin_credentials[:user], @session["session_id"])
  end

  it "should create admin user" do
    visit '/'
    find_link("System").click
    find_link("Authentication").click
    click_link_or_button("Add new user")

    find(:id, "username").set @adminName
    find(:id, "fullname").set "John Doe"
    find(:id, "email").set "test@example.org"
    find(:id, "password").set "123456"
    find(:id, "password-repeat").set "123456"
    within(:xpath, '//div[@class="form-group" and descendant::node()[text()="Roles"]]') do
      find(:css, "div.Select-control input").set "Admin"
    end
    click_button("Create User")
    expect(page).to have_link(@adminName)
  end

  it "should delete admin user" do
    visit '/'
    find_link("System").click
    find_link("Authentication").click
    accept_alert "Do you really want to delete user #{@adminName}?" do
      within(:id,"user-list") do
        find(:id, "delete-user-#{@adminName}" ).click
      end
    end

    expect(page).not_to have_link(@adminName)
  end

  it "should create readonly user" do
    visit '/'
    find_link("System").click
    find_link("Authentication").click
    click_link_or_button("Add new user")

    find(:id, "username").set @userName
    find(:id, "fullname").set "John Reader"
    find(:id, "email").set "test@example.org"
    find(:id, "password").set "123456"
    find(:id, "password-repeat").set "123456"
    within(:xpath, '//div[@class="form-group" and descendant::node()[text()="Roles"]]') do
      find(:css, "div.Select-control input").set "Reader"
    end
    click_button("Create User")
    expect(page).to have_link(@userName)
  end

  it "should edit username" do
    visit '/'
    find_link("System").click
    find_link("Authentication").click
    within(:id, "user-list") do
      find(:id, "edit-user-#{@userName}").click
    end
    find(:id, "full_name").set @userName
    click_button("Update User")
    expect(page).to have_link(@userName)
  end

  it "should edit userrole" do
    visit '/'
    find_link("System").click
    find_link("Authentication").click
    within(:id, "user-list") do
      find(:id, "edit-user-#{@userName}").click
    end
    within(:xpath, '//div[@class="form-group" and descendant::node()[text()="Roles"]]') do
      find(:css, "div.Select-control input").set "Reader"
    end
  end

  it "should delete readonly user" do
    visit '/'
    find_link("System").click
    find_link("Authentication").click
    accept_alert "Do you really want to delete user #{@userName}?" do
      within(:id, "user-list") do
        find(:id, "delete-user-#{@userName}" ).click
      end
    end
    expect(page).not_to have_link(@userName)
  end
end
