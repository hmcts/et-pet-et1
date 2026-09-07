class AddLastEventDateToClaims < ActiveRecord::Migration[8.1]
  def change
    add_column :claims, :last_event_date, :date
  end
end
