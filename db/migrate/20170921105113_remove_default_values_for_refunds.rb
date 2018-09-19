class RemoveDefaultValuesForRefunds < ActiveRecord::Migration[4.2]
  def change
    change_column_default :refunds, :et_issue_fee, nil
    change_column_default :refunds, :et_issue_fee_currency, 'GBP'

  end
end
