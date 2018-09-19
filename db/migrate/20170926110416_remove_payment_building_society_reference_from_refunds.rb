class RemovePaymentBuildingSocietyReferenceFromRefunds < ActiveRecord::Migration[4.2]
  def change
    remove_column :refunds, :payment_building_society_reference, :string
  end
end
