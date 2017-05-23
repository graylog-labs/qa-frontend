include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Stream functionality", :type => :feature do
  include_examples "authenticated"

  before(:all) do
    @streamName = randomName
  end

  before(:each) do
    visit "/streams"
  end

  it "creates new stream" do
    click_button("Create Stream")

    within(modal_dialog) do
      fill_in(name: "Title", with: @streamName)
      fill_in(name: "Description", with: "Testing")
      click_on("Save")
    end
    expect(page).to match have_link(@streamName)
    expect(page).to have_text("Stopped")
    expect(page).to have_content("Testing")
  end

  it "adds stream rule" do
    within(find_stream(@streamName)) do
      click_on("Manage Rules")
    end
    click_on("Add stream rule")

    within(modal_dialog) do
      fill_in("Field", class: "tt-input", with: "message")
      fill_in(name: "Value", with: "foo")
      click_on("Save")
    end

    expect(streamrules_list).to have_text("Field message must match exactly foo")

    click_on "I'm done!"

    within(find_stream(@streamName)) do
      click_on "Show stream rules"
      expect(streamrules_list).to have_text("Field message must match exactly foo")
    end
  end

  it "starts a stopped stream" do
    within(find_stream(@streamName)) do
      click_on "Start Stream"
    end

    expect(find_stream(@streamName)).to have_no_content("Stopped")
  end

  it "pauses a running stream" do
    within(find_stream(@streamName)) do
      accept_alert("Do you really want to pause stream '#{@streamName}'?") do
        click_on "Pause Stream"
      end
    end

    expect(find_stream(@streamName)).to have_content("Stopped")
  end

  it "changes the field name of a stream rule using streamrules list in overview" do
    within(find_stream(@streamName)) do
      click_on "Show stream rules"
      within(streamrules_list) do
        within(find_streamrule("Field message must match exactly foo")) do
          find("i", class: "fa-edit").click
        end
      end
    end

    within(modal_dialog) do
      fill_in("Field", class: "tt-input", with: "source")

      click_on "Save"
    end

    within(find_stream(@streamName)) do
      click_on "Show stream rules"
    end

    expect(find_stream(@streamName)).not_to have_text("Field message must match exactly foo")
    expect(find_stream(@streamName)).to have_text("Field source must match exactly foo")
  end

  it "deletes a stream rule using streamrules list in overview" do
    within(find_stream(@streamName)) do
      click_on "Show stream rules"
      within(streamrules_list) do
        within(find_streamrule("Field source must match exactly foo")) do
          accept_alert "Do you really want to delete this stream rule?" do
            find("i", class: "fa-trash-o").click
          end
        end
      end

      click_on "Show stream rules"
      expect(streamrules_list).not_to have_text("Field message must match exactly foo")
      expect(streamrules_list).to have_text("No rules defined.")
    end
  end

  it "deletes the stream" do
    within(find_stream(@streamName)) do
      click_button("More Actions")
      accept_alert "Do you really want to remove this stream" do
        click_link("Delete this stream")
      end
    end
    expect(page).to have_no_link(@streamName)
  end

  def find_stream(streamName, options = {})
    find("li", class: "stream", text: streamName)
  end

  def modal_dialog
    find("div", class: "modal")
  end

  def streamrules_list
    find("ul", class: "streamrules-list")
  end

  def find_streamrule(streamRule)
    find("li", text: streamRule)
  end
end
