module GraylogHelpers
  def navigation_bar(options = {})
    find(:css, "nav.navbar")
  end
end
