class RenameAttachmentsColumnOnClaim < ActiveRecord::Migration[4.2]
  def change
    rename_column :claims, :attachment, :additional_information_rtf
  end
end
