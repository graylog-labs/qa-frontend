include RSpec::Expectations
include SessionHelpers
include GenericHelpers
include GraylogHelpers

describe "Navigation", :type => :feature do
  include_examples "authenticated"

  before(:each) do
    visit "/"
  end

  %w(Search Streams Alerts Dashboards Sources).each do |item|
    it "should have a #{item} link" do
      expect(navigation_bar).to have_link(item, href: "/#{item.downcase}")
    end
  end

  it "should have a System menu" do
    expect(navigation_bar).to have_link("System")
  end

  it "should have a System menu dropdown when clicking System" do
    within(navigation_bar) do
      click_on "System"

      dropdown = find("ul", class: "dropdown-menu", visible: true)
      ["Overview", "Configurations", "Nodes", "Inputs", "Outputs", "Indices", "Logging",
        "Authentication", "Content Packs", "Grok Patterns", "Lookup Tables"].each do |item|
        expect(dropdown).to have_link(item, href: "/system/#{item.downcase.gsub /\s/, ''}")
      end
    end
  end
end
