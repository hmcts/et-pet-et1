class AddExtrafieldsToEmploymentDetails < ActiveRecord::Migration
  def change
    add_column :employment_details, :weeks_paid_frequency, :string
    add_column :employment_details, :worked_period_of_notice, :string
    add_column :employment_details, :another_job, :string
  end
end
