class ConvertFeesToDecimalsInRefunds < ActiveRecord::Migration[4.2]
  def up
    change_column :refunds, :et_issue_fee, :decimal, precision: 10, scale: 2
    change_column :refunds, :et_hearing_fee, :decimal, precision: 10, scale: 2
    change_column :refunds, :et_reconsideration_fee, :decimal, precision: 10, scale: 2
    change_column :refunds, :eat_issue_fee, :decimal, precision: 10, scale: 2
    change_column :refunds, :eat_hearing_fee, :decimal, precision: 10, scale: 2
  end
  def down
    change_column :refunds, :et_issue_fee, :integer
    change_column :refunds, :et_hearing_fee, :integer
    change_column :refunds, :et_reconsideration_fee, :integer
    change_column :refunds, :eat_issue_fee, :integer
    change_column :refunds, :eat_hearing_fee, :integer
  end
end
