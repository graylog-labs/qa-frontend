include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Dashboard functionality", :type => :feature do
  include_examples "authenticated"

  before(:all) do
    @dashboardName = randomName
    @newdashboardName = randomName
  end

  before(:each) do
    visit "/dashboards"
  end

  it "creates new dashboard" do
    expect(page).not_to have_link(@dashboardName)

    click_button("Create dashboard")
    fill_in("Title", with: @dashboardName)
    fill_in("Description", with: "Testing")
    click_button("Save")

    expect(page).to have_link(@dashboardName)
  end

  it "changes title of existing dashboard" do
    within(find_dashboard(@dashboardName)) do
      click_on("Edit dashboard")
    end
    fill_in("Title", with: @newdashboardName)
    fill_in("Description", with: "Edited")
    click_on("Save")

    expect(page).to have_link(@newdashboardName)
    expect(find_dashboard(@newdashboardName)).to have_text("Edited")
  end

  it "deletes existing dashboard" do
    within(find_dashboard(@newdashboardName)) do
      click_on "More actions"

      accept_alert "Do you really want to delete the dashboard #{@newdashboardName}" do
        click_on("Delete this dashboard")
      end
    end

    expect(page).not_to have_link(@newdashboardName)
  end

  def find_dashboard(dashboardName)
    find("li", class: "stream", text: dashboardName)
  end
end
