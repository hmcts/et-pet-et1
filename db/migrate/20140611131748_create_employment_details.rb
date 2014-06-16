class CreateEmploymentDetails < ActiveRecord::Migration
  def change
    create_table :employment_details do |t|
      t.string :job_title
      t.date :start_date
      t.string :hours_worked
      t.string :pay_before_tax
      t.string :pay_before_tax_frequency
      t.string :take_home_pay
      t.string :take_home_pay_frequency
      t.string :pension_scheme
      t.string :details_of_benefit
      t.string :current_situation

      t.timestamps
    end
  end
end
