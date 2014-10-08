class AddAttachmentToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :attachment, :string
  end
end
