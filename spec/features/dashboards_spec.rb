include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Dashboards", :type => :feature do
  include_examples "authenticated"

  before(:all) do
    @dashboardName = randomName
    @newdashboardName = randomName
    visit "/dashboards"
  end

  it "should create new dashboard" do
    expect(page).not_to have_link(@dashboardName)
    click_button("Create dashboard")
    fill_in("Title", with: @dashboardName)
    fill_in("Description", with: "Testing")
    click_button("Save")
    expect(page).to have_link(@dashboardName)
  end

  it "should edit dashboard" do
    within(find_dashboard(@dashboardName)) do
      click_on("Edit dashboard")
    end
    fill_in("Title", with: @newdashboardName)
    fill_in("Description", with: "Edited")
    click_on("Save")

    expect(page).to have_link(@newdashboardName)
    expect(find_dashboard(@newdashboardName)).to have_text("Edited")
  end

  it "should delete new dashboard" do
    within(find_dashboard(@newdashboardName)) do
      click_on "More actions"

      accept_alert "Do you really want to delete the dashboard #{@newdashboardName}" do
        click_on("Delete this dashboard")
      end
    end

    expect(page).not_to have_link(@newdashboardName)
  end

  def find_dashboard(dashboardName)
    find(:xpath, "//li[@class=\"stream\" and descendant::node()[text()=\"" + dashboardName + "\"]]")
  end
end
