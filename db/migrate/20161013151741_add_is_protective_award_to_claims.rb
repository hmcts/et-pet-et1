class AddIsProtectiveAwardToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :is_protective_award, :boolean, default: false
  end
end
