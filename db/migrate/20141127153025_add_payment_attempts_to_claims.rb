class AddPaymentAttemptsToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :payment_attempts, :integer, default: 0
  end
end
