class ApplyToSelection < RubyLLM::Tool
  description "Blocks, unblocks or deletes the currently selected users. " \
              "Use only when the user explicitly asks for it."
  parameter :action, type: :string, description: "Exactly 'block', 'unblock' or 'delete'", required: true

  def execute(action:)
    ids = Array(Current.selection)
    return { error: "No users are selected. Select users first." } if ids.empty?

    users = User.where(id: ids)
    affected =
      case action
      when "block"   then users.update_all(status: User.statuses[:blocked])
      when "unblock" then users.update_all(status: User.statuses[:active])
      when "delete"  then users.delete_all
      else return { error: "Unknown action '#{action}'." }
      end

    Current.selection = []
    Current.selection_changed = true
    Current.data_changed = true
    { action: action, affected: affected }
  end
end
