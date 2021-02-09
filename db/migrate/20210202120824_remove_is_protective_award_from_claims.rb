class RemoveIsProtectiveAwardFromClaims < ActiveRecord::Migration[6.0]
  def change
    remove_column :claims, :is_protective_award, :boolean, default: false
  end
end
