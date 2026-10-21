class SelectUsers < RubyLLM::Tool
  include UserFilter

  description "Select the checkboxes of all users matching the filters in the table and replaces " \
              "the current selection. With no filters it selects everyone. Does not change any data."

  def execute(**filters)
    ids = filtered_users(**filters).pluck(:id)
    Current.selection = ids
    Current.selection_changed = true
    { selected: ids.size }
  end
end
