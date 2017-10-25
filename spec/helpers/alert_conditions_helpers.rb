module AlertConditionsHelpers
  def alert_conditions_list
    find("ul.entity-list")
  end

  def condition_details
    find("h2", text: "Condition details")
      .first(:xpath, ".//..")
  end

  def alert_condition_entry(alertConditionName)
    alert_conditions_list.find("li", text: alertConditionName)
  end

  def type_condition_select
    find(:select, "Condition type")
  end
end
