class AddIsProtectiveAwardToClaims < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :is_protective_award, :boolean, default: false
  end
end
