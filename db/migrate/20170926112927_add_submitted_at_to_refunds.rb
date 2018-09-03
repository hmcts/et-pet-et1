class AddSubmittedAtToRefunds < ActiveRecord::Migration[4.2]
  def change
    add_column :refunds, :submitted_at, :datetime
  end
end
