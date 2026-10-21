class ClearSelection < RubyLLM::Tool
  description "Deselect all checkboxes. Does not change any data."

  def execute
    Current.selection = []
    Current.selection_changed = true
    { selected: 0 }
  end
end
