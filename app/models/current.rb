class Current < ActiveSupport::CurrentAttributes
  attribute :feature_flag_values, default: {}
end
