include RSpec::Expectations
include GenericHelpers
include SessionHelpers

Capybara.default_max_wait_time = 10

describe "User page", :type => :feature do
  include_examples "authenticated"

  before(:all) do
    @adminName = randomName
    @userName = randomName
  end

  before(:each) do
    visit "/system/authentication"
  end

  it "creates admin user" do
    click_link_or_button("Add new user")

    fill_in "Username", with: @adminName
    fill_in "Full Name", with: "John Doe"
    fill_in "Email Address", with: "test@example.org"
    fill_in "Password", with: "123456"
    find(:id, "password-repeat").set "123456"

    clear_typeahead "Roles"
    fill_typeahead "Roles", with: "Admin"

    click_button("Create User")

    expect(page).to have_link(@adminName)
    expect(user_row(@adminName)).to have_text("Admin")
    expect(user_row(@adminName)).not_to have_text("Reader")
  end

  it "deletes admin user" do
    accept_alert "Do you really want to delete user #{@adminName}?" do
      within(user_row(@adminName)) do
        click_on "Delete"
      end
    end

    expect(page).not_to have_link(@adminName)
  end

  it "creates readonly user" do
    click_link_or_button("Add new user")

    fill_in "Username", with: @userName
    fill_in "Full Name", with: "John Reader"
    fill_in "Email Address", with: "test@example.org"
    fill_in "Password", with: "123456"
    find(:id, "password-repeat").set "123456"

    clear_typeahead "Roles"
    fill_typeahead "Roles", with: "Reader"
    click_button("Create User")

    expect(page).to have_text(@userName)
    expect(user_row(@userName)).to have_text("Reader")
    expect(user_row(@userName)).not_to have_text("Admin")
  end

  it "edits username" do
    within(user_row(@userName)) do
      click_on "Edit"
    end

    fill_in "Full Name", with: "The new full name"
    click_button("Update User")

    expect(page).to have_text("The new full name")
    expect(page).not_to have_text("John Reader")
    expect(user_row(@userName)).to have_text("The new full name")
    expect(user_row(@userName)).not_to have_text("John Reader")
  end

  it "edits userrole" do
    within(user_row(@userName)) do
      click_on "Edit"
    end

    clear_typeahead "Roles"
    fill_typeahead "Roles", with: "Reader"

    accept_alert "Really update roles for \"#{@userName}\"?" do
      click_on "Update role"
    end

    expect(user_row(@userName)).to have_text "Reader"
  end

  it "deletes readonly user" do
    accept_alert "Do you really want to delete user #{@userName}?" do
      within(user_row(@userName)) do
        click_on "Delete"
      end
    end
    expect(page).not_to have_link(@userName)
  end

  def user_row(username)
    find("tr", text: username)
  end
end
