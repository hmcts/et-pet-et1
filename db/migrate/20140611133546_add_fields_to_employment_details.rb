class AddFieldsToEmploymentDetails < ActiveRecord::Migration
  def change
    add_column :employment_details, :employment_ended, :date
    add_column :employment_details, :weeks_paid, :string
    add_column :employment_details, :another_job_start_date, :date
    add_column :employment_details, :another_job_pay_before_tax, :string
    add_column :employment_details, :notice_period_end_date, :date
  end
end
