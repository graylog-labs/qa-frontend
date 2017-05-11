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
    click_link("Streams")
    expect(current_path).to be("/streams")
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
      click_on("Manage Rules")
    end
    click_on("Add stream rule")

    within(find(:id, "StreamRuleForm")) do
      fill_in("Field", with: "message", class: "tt-input")
      fill_in("Value", with: "foo")
      click_on("Save")
    end

    expect(find("ul", class: "streamrules-list")).to have_text("Field message must match exactly foo")
  end

  it "should start the stream" do
    visit "/streams"
    within(find_stream(@streamName, wait: 30)) do
      click_on "Start Stream"
    end

    expect(find_stream(@streamName)).to have_no_content("Stopped", wait: 30)
  end

  it "should pause the stream" do
    visit "/streams"
    within(find_stream(@streamName, wait: 30)) do
      accept_alert("Do you really want to pause stream '#{@streamName}'?") do
        click_on "Pause Stream"
      end
    end

    expect(find_stream(@streamName)).to have_content("Stopped", wait: 30)
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
