include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Creating a stream", :type => :feature do
  include_examples "authenticated"

  before(:all) do
    @streamName = randomName
  end

  it "should create stream" do
    visit '/'
    find_link("Streams").click
    click_button("Create Stream")

    fill_in("Title", with: @streamName)
    fill_in("Description", with: "Testing")
    click_on("Save")
    expect(page).to match have_link(@streamName, wait: 30)
    expect(page).to have_text("Stopped")
    expect(page).to have_content("Testing")
  end

  it "should add stream rule" do
    visit "/streams"
    within(find_stream(@streamName, wait: 30)) do
      click_link("Manage Rules")
    end

    click_link_or_button("Add stream rule")
    find(:xpath, "//input[@label='Field' and contains(@class, 'tt-input')]").set "message"
    fill_in("Value", with: "foo")
    click_link_or_button("Save")

    expect(page).to have_selector(:xpath, "//ul[@class=\"streamrules-list\"]/li[descendant::node()[text()=\"foo\"]]")
  end

  it "should start the stream" do
    visit "/streams"
    within(find_stream(@streamName, wait: 30)) do
      click_on "Start Stream"
    end

    expect(find_stream(@streamName)).to have_no_content("Stopped", wait: 30)
  end

  it "should delete the stream" do
    visit "/streams"
    within(find_stream(@streamName, wait: 30)) do
      click_button("More Actions")
      accept_alert "Do you really want to remove this stream" do
        click_link("Delete this stream")
      end
    end
    expect(page).to have_no_link(@streamName, wait: 30)
  end

  def find_stream(streamName, options = {})
    find(:xpath, "//li[@class=\"stream\" and descendant::node()[text()=\"" + streamName + "\"]]", options)
  end
end
