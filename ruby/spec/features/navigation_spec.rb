include RSpec::Expectations
include SessionHelpers
include GenericHelpers
include GraylogHelpers

describe "Navigation", :type => :feature do
  include_examples "authenticated"

  it "should have a Search link" do
    visit "/"
    expect(navigation_bar).to have_link("Search")
  end

  it "should have a Streams link" do
    visit "/"
    expect(navigation_bar).to have_link("Streams")
  end

  it "should have a Alerts link" do
    visit "/"
    expect(navigation_bar).to have_link("Alerts")
  end

  it "should have a Dashboards link" do
    visit "/"
    expect(navigation_bar).to have_link("Dashboards")
  end

  it "should have a Sources link" do
    visit "/"
    expect(navigation_bar).to have_link("Sources")
  end

  it "should have a System link" do
    visit "/"
    expect(navigation_bar).to have_link("System")
  end
end
