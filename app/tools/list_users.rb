class ListUsers < RubyLLM::Tool
  include UserFilter

  LIMIT = 10

  description "Lists users matching the filters (name, e-mail, job position, status, last seen), " \
              "most recently seen first. Returns at most #{LIMIT} users and the true total."

  def execute(**filters)
    scope = filtered_users(**filters)
    {
      total: scope.count,
      shown: [ scope.count, LIMIT ].min,
      users: scope.order(Arel.sql("last_seen DESC NULLS LAST"), :id).limit(LIMIT)
                  .map { |u| u.slice(:full_name, :email, :job_position, :status, :last_seen) }
    }
  end
end
