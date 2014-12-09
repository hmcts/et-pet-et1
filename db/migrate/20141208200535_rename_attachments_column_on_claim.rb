class RenameAttachmentsColumnOnClaim < ActiveRecord::Migration
  def change
    rename_column :claims, :attachment, :additional_information_rtf
  end
end
