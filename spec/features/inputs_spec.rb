include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Inputs functionality", :type => :feature do
  include_examples "authenticated"

  before (:all) do
    @inputName = randomName
  end

  before(:each) do
    visit "/system/inputs"
  end

  it "creates local input" do
    find(".Select-input input").set "Random HTTP message generator\n"
    find(".form-control select").click
    fill_in("Title", with: @inputName)
    click_button("Launch new input")
  end
end
