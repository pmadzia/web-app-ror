module UserFilter
  COLUMNS = %i[full_name email job_position].freeze

  MATCHES = {
    starts_with: [ "starts with", ->(t) { "#{t}%" } ],
    contains:    [ "contains",    ->(t) { "%#{t}%" } ],
    ends_with:   [ "ends with",   ->(t) { "%#{t}" } ]
  }.freeze

  TEXT_FILTERS = COLUMNS.flat_map do |column|
    MATCHES.map do |match, (words, pattern)|
      [ :"#{column}_#{match}",
        [ :string, "#{column.to_s.humanize} #{words} this text. " \
                   "Several values separated by commas match ANY of them, e.g. 'b,c'",
          ->(s, v) {
            patterns = like_patterns(v, pattern)
            next s if patterns.empty?
            s.where(([ "#{column} ILIKE ?" ] * patterns.size).join(" OR "), *patterns)
          } ] ]
    end
  end.to_h

  ALL_FILTERS = TEXT_FILTERS.merge(
    seen_within_days: [ :integer, "Last seen within the last N days",
      ->(s, v) { s.where(last_seen: v.to_i.days.ago..) } ],
    status: [ :string, "'active' or 'blocked'",
      ->(s, v) { s.where(status: v) if User.statuses.key?(v.to_s) } ]
  ).freeze

  def self.like_patterns(value, pattern)
    Array(value).flat_map { |v| v.to_s.split(",") }
                .map(&:strip).reject(&:blank?)
                .map { |text| pattern.call(User.sanitize_sql_like(text)) }
  end

  def self.like(text) = User.sanitize_sql_like(text.to_s)

  def self.included(tool)
    ALL_FILTERS.each { |name, (type, desc)| tool.parameter name, type: type, description: desc, required: false }
  end

  def filtered_users(**filters)
    ALL_FILTERS.reduce(User.all) do |scope, (name, definition)|
      value = filters[name]
      value.blank? ? scope : (definition.last.call(scope, value) || scope)
    end
  end
end
