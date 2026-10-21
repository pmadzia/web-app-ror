class CountUsers < RubyLLM::Tool
  include UserFilter

  description "Counts users matching the filters. Use this for every 'how many' question. " \
              "With no filters it returns the total number of users."

  def execute(**filters)
    { count: filtered_users(**filters).count }
  end
end
