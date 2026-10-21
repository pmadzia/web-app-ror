class Current < ActiveSupport::CurrentAttributes
  attribute :selection, :selection_changed, :data_changed
end