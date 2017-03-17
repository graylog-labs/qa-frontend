include RSpec::Expectations
require 'pp'
include SessionHelpers

describe "Creating a stream", :type => :feature do

  before(:all) do
    @session = register_session(admin_credentials[:user], admin_credentials[:password])
    @streamName = randomStreamName
  end
  
  def streamItemSelector(streamName)
    "//li[@class=\"stream\" and descendant::node()[text()=\"" + streamName + "\"]]"
  end

  def randomStreamName
    ('a'..'z').to_a.shuffle[0,8].join
  end
  
  it "should create stream" do
    visit '/'
    login_with_valid_session(admin_credentials[:user], @session["session_id"])
    visit '/'
    find_link("Streams").click
    click_button("Create Stream")
    
    find(:xpath, "//input[@label='Title']").set @streamName
    find(:xpath, "//input[@label='Description']").set "Testing"
    find(:xpath, "//button[.='Save']").click
    expect(page).to have_link(@streamName, wait: 30)
    expect(page).to have_selector(:xpath, "//li[@class=\"stream\" and descendant::node()[text()=\"" + @streamName + "\"]]/descendant::node()[text()=\"Stopped\"]")
    expect(page).to have_selector(:xpath, "//li[@class=\"stream\" and descendant::node()[text()=\"" + @streamName + "\"]]/descendant::node()[@class=\"stream-description\"]/descendant::node()[text()=\"Testing\"]")
  end
  
  it "should add stream rule" do
    visit "/streams"
    selector = streamItemSelector(@streamName)
    expect(find(:xpath, selector, wait: 30))
    within(:xpath, selector) do
      click_link("Manage Rules")
    end
    
    click_link_or_button("Add stream rule")
    find(:xpath, "//input[@label='Field' and contains(@class, 'tt-input')]").set "message"
    find(:xpath, "//input[@label='Value']").set "foo"
    click_link_or_button("Save")
    
    expect(page).to have_selector(:xpath, "//ul[@class=\"streamrules-list\"]/li[descendant::node()[text()=\"foo\"]]")
  end

  it "should delete the stream" do
    visit "/streams"
    selector = streamItemSelector(@streamName)
    expect(find(:xpath, selector, wait: 30))
    within(:xpath, selector) do
      click_button("More Actions")
      accept_alert "Do you really want to remove this stream" do
        click_link("Delete this stream")
      end
    end
    sleep 2
    expect(page).not_to have_selector(:xpath, "//li[@class=\"stream\" and descendant::node()[text()=\"" + @streamName + "\"]]")
  end
end
