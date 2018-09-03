class AddAttachmentToClaims < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :attachment, :string
  end
end
