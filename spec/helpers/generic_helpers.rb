module Capybara
  module Node
    class Element
      def has_placeholder?(text)
        has_selector?(:option, disabled: true, text: text)
      end
    end
  end
end

module GenericHelpers
  def randomName
    ('a'..'z').to_a.shuffle[0,8].join
  end

  def fill_typeahead(title, options)
    value = options.delete(:with)
    select = find("label", text: title)
      .first(:xpath, ".//..")
      .find("div", { class: "Select" }.merge(options))
      .click
    select.find("div", text: /^\s*#{value}\s*$/).click
  end

  def clear_typeahead(title, options = {})
    find("label", text: title)
      .first(:xpath, ".//..")
      .find("span", class: "Select-clear")
      .click
  end
end
