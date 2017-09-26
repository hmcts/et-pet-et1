class RemovePaymentBuildingSocietyReferenceFromRefunds < ActiveRecord::Migration
  def change
    remove_column :refunds, :payment_building_society_reference, :string
  end
end
