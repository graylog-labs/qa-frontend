include SessionHelpers
include GenericHelpers
include Capybara::DSL

def login_as_admin
  @session = register_session(admin_credentials[:user], admin_credentials[:password])
  puts @session
  visit '/'
  login_with_valid_session(admin_credentials[:user], @session["session_id"])
end

login_as_admin
visit "/"
