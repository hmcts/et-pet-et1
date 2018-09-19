class AddWorkedAtDifferentAddressToRespondents < ActiveRecord::Migration[4.2]
  def change
    add_column :respondents, :worked_at_different_address, :boolean, default: false
  end
end
