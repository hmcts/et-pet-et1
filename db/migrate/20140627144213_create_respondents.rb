class CreateRespondents < ActiveRecord::Migration
  def change
    create_table :respondents do |t|
      t.string :name
      t.string :acas_early_conciliation_certificate_number
      t.string :no_acas_number_reason

      t.integer :claim_id
      t.timestamps
    end
  end
end
