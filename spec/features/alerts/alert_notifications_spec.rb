include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Alert Notifications", :type => :feature do
  include_examples "authenticated"

  before(:all) do
    @alarmNotificationName = randomName
  end

  before(:each) do
    visit "/alerts/notifications"
  end

  it "create a new HTTP Alarm Callback for All messages stream" do
    click_on "Add new notification"
    fill_typeahead "Notify on stream", with: "All messages"

    expect(page).to have_select("Notification type", with_options: [
      "HTTP Alarm Callback",
      "Email Alert Callback"
    ])
    expect(type_condition_select).to have_placeholder("Select a notification type")
    select "HTTP Alarm Callback", from: "Notification type"

    click_on "Add alert notification"

    fill_in id: "title", with: @alarmNotificationName
    fill_in id: "url", with: "http://ex.amp.le/foo"

    click_on "Save"

    entry = alarm_notification_entry(@alarmNotificationName)
    expect(entry).to have_text("(HTTP Alarm Callback)")
    expect(entry).to have_text("http://ex.amp.le/foo")
    expect(entry).to have_text("Executed once per triggered alert condition in stream All messages")
  end

  it "edit an existing alarm notification and change URL" do
    within(alarm_notification_entry(@alarmNotificationName)) do
      click_on "More actions"
      click_on "Edit"
    end

    fill_in id: "url", with: "https://www.graylog.org/test"

    click_on "Save"

    entry = alarm_notification_entry(@alarmNotificationName)
    expect(entry).to have_text("(HTTP Alarm Callback)")
    expect(entry).to have_text("https://www.graylog.org/test")
    expect(entry).to have_text("Executed once per triggered alert condition in stream All messages")
  end

  it "delete an existing alarm notification" do
    within(alarm_notification_entry(@alarmNotificationName)) do
      click_on "More actions"

      accept_alert("Really delete alert notification?") do
        click_on "Delete"
      end
    end

    expect(page).not_to have_text(@alarmNotificationName)
  end

  def alarm_notifications_list
    find("ul.entity-list")
  end

  def alarm_notification_entry(alertConditionName)
    alarm_notifications_list.find("li", text: alertConditionName)
  end

  def type_condition_select
    find(:select, "Notification type")
  end
end
