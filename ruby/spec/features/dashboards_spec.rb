include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Dashboards", :type => :feature do
  before(:all) do
    @dashboardName = randomName
    @session = register_session(admin_credentials[:user], admin_credentials[:password])
    visit '/'
    login_with_valid_session(admin_credentials[:user], @session["session_id"])
  end

  it "should create new dashboard" do
    visit "/"
    find_link("Dashboards").click

    expect(page).not_to have_link(@dashboardName)

    click_button("Create dashboard")

    find(:xpath, "//input[@label='Title:']").set @dashboardName
    find(:xpath, "//input[@label='Description:']").set "Testing"
    find(:xpath, "//button[.=\"Save\"]").click

    expect(page).to have_link(@dashboardName)
  end

  it "should delete new dashboard" do
    visit "/dashboards"

    find(:xpath, "//li[@class=\"stream\" and descendant::node()[text()=\"" + @dashboardName + "\"]]/descendant::node()[text()=\"More actions\"]").click

    accept_alert "Do you really want to delete the dashboard #{@dashboardName}" do
      find(:xpath, "//li[@class=\"stream\" and descendant::node()[text()=\"" + @dashboardName + "\"]]/descendant::node()[text()=\"Delete this dashboard\"]").click
    end

    expect(page).not_to have_link(@dashboardName)
    clear_session
  end
end
