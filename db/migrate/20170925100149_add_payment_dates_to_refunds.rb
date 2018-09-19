class AddPaymentDatesToRefunds < ActiveRecord::Migration[4.2]
  def change
    add_column :refunds, :et_issue_fee_payment_date, :date
    add_column :refunds, :et_issue_fee_payment_date_unknown, :boolean
    add_column :refunds, :et_hearing_fee_payment_date, :date
    add_column :refunds, :et_hearing_fee_payment_date_unknown, :boolean
    add_column :refunds, :et_reconsideration_fee_payment_date, :date
    add_column :refunds, :et_reconsideration_fee_payment_date_unknown, :boolean
    add_column :refunds, :eat_issue_fee_payment_date, :date
    add_column :refunds, :eat_issue_fee_payment_date_unknown, :boolean
    add_column :refunds, :eat_hearing_fee_payment_date, :date
    add_column :refunds, :eat_hearing_fee_payment_date_unknown, :boolean
  end
end
