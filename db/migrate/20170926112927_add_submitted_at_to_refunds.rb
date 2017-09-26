class AddSubmittedAtToRefunds < ActiveRecord::Migration
  def change
    add_column :refunds, :submitted_at, :datetime
  end
end
