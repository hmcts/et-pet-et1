class RemoveDefaultValuesForRefunds < ActiveRecord::Migration
  def change
    change_column_default :refunds, :et_issue_fee, nil
    change_column_default :refunds, :et_issue_fee_currency, 'GBP'

  end
end
