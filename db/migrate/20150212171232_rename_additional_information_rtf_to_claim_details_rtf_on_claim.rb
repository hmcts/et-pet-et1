class RenameAdditionalInformationRtfToClaimDetailsRtfOnClaim < ActiveRecord::Migration[4.2]
  def change
    rename_column :claims, :additional_information_rtf, :claim_details_rtf
  end
end
