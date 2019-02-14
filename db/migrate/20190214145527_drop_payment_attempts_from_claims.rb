class DropPaymentAttemptsFromClaims < ActiveRecord::Migration[5.2]
  def change
    remove_column :claims, :payment_attempts, :integer, default: 0
  end
end
