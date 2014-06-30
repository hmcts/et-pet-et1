class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.boolean :enrolled_in_pension_scheme
      t.boolean :found_new_employment
      t.boolean :worked_notice_period_or_paid_in_lieu
      t.date :end_date
      t.date :new_job_start_date
      t.date :notice_period_end_date
      t.date :start_date
      t.float :notice_pay_period_count
      t.integer :gross_pay
      t.integer :net_pay
      t.integer :new_job_gross_pay
      t.float :average_hours_worked_per_week
      t.string :current_situation
      t.string :gross_pay_period_type
      t.string :job_title
      t.string :net_pay_period_type
      t.string :new_job_gross_pay_frequency
      t.string :notice_pay_period_type
      t.text :benefit_details

      t.integer :claim_id

      t.timestamps
    end
  end
end
