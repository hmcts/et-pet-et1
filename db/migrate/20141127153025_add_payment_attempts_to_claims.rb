class AddPaymentAttemptsToClaims < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :payment_attempts, :integer, default: 0
  end
end
