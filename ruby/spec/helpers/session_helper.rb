module SessionHelpers
  def register_session(username, password, host = "capybara")
    payload = { username: username, password: password, host: "capybara" }
    response = RestClient.post(api_host + "/system/sessions", payload.to_json, { content_type: :json, accept: :json })
    return JSON.parse(response)
  end

  def login_with_valid_session(user, sessionId)
    setSession = %Q[localStorage.setItem('sessionId', "\\"#{sessionId}\\"")]
    setUsername = %Q[localStorage.setItem('username', "\\"#{user}\\"")]
    page.evaluate_script(setUsername)
    page.evaluate_script(setSession)
  end

  def clear_session
    page.evaluate_script(%Q[localStorage.setItem('sessionId', '')])
    page.evaluate_script(%Q[localStorage.setItem('username', '')])
  end
end
