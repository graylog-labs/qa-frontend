include RSpec::Expectations
include GraylogHelpers

describe "Logout", :type => :feature do
  include_examples "authenticated"

  it "should logout the user" do
    visit "/"
    within(navigation_bar) do
      click_on("Administrator")
      click_on("Log out")
    end
    expect(page).to have_field("Username")
  end
end
