class RenameIncorrectFieldsInRefunds < ActiveRecord::Migration[4.2]
  class Refund < ActiveRecord::Base
    self.table_name = :refunds
  end

  def up
    rename_column :refunds, :applicant_email_address, :claimant_email_address
    rename_column :refunds, :email_address, :applicant_email_address
    Refund.find_each batch_size: 100 do |r|
      r.claimant_email_address = r.applicant_email_address
      r.save
    end
  end
  def down
    rename_column :refunds, :applicant_email_address, :email_address
    rename_column :refunds, :claimant_email_address, :applicant_email_address
  end
end
