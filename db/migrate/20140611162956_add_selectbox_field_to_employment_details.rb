class AddSelectboxFieldToEmploymentDetails < ActiveRecord::Migration
  def change
    add_column :employment_details, :another_job_pay_before_tax_frequency, :string
  end
end
