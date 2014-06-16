class AddAcasReasonToEmployersDetails < ActiveRecord::Migration
  def change
    add_column :employers_details, :acas_reason, :string
  end
end
