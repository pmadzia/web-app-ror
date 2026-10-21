class ChatController < ApplicationController
  SYSTEM_PROMPT = <<~TEXT.freeze
    You answer questions about the users of this application and control its user table.
    Never guess or calculate numbers yourself: always call a tool and report exactly what it returns.
    To select checkboxes use select_users; to deselect use clear_selection.
    Block, unblock or delete only when the user explicitly asks, and only through apply_to_selection,
    which works on the currently selected users (select them first if needed).
    Say that an action was done only if the tool result confirms it, and report the real count.
    If a request cannot be done with the tools, say so.
    Answer briefly in plain text.
  TEXT

  TOOLS = [ CountUsers, ListUsers, SelectUsers, ClearSelection, ApplyToSelection ].freeze

  def create
    question = params[:message].to_s.strip
    return head(:unprocessable_entity) if question.blank?

    Current.selection = Array(params[:selected_ids]).map(&:to_i)
    answer = answer_to(question)
    streams = [
      turbo_stream.append("chat_messages", partial: "chat/message",
                          locals: { role: "user", text: question }),
      turbo_stream.append("chat_messages", partial: "chat/message",
                          locals: { role: "assistant", text: answer })
    ]
    streams << ui_update if Current.selection_changed
    render turbo_stream: streams
  end

  private

  def answer_to(question)
    chat = RubyLLM.chat(model: ENV.fetch("AI_MODEL", "gemini-3.5-flash"),
                        provider: :gemini, assume_model_exists: true)
    chat.with_instructions(SYSTEM_PROMPT)
    chat.with_tools(*TOOLS)
    chat.ask(question).content
  rescue RubyLLM::Error => e
    Rails.logger.error("Chat failed: #{e.message}")
    "Chatbot is not available right now."
  end

  def ui_update
    if Current.data_changed
      q = User.ransack(nil)
      q.sorts = "last_seen_or_epoch desc"
      turbo_stream.replace("users_list", partial: "admin/users_list",
                           locals: { q: q, users: q.result.order(:id) })
    else
      turbo_stream.action(:set_selection, "users_list", Array(Current.selection).join(","))
    end
  end
end
