class RemoveDefaultFromWorkedAtSameAddressInRespondents < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:respondents, :worked_at_same_address, from: true, to: nil)
  end
end
