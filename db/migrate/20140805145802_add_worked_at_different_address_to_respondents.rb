class AddWorkedAtDifferentAddressToRespondents < ActiveRecord::Migration
  def change
    add_column :respondents, :worked_at_different_address, :boolean, default: false
  end
end
