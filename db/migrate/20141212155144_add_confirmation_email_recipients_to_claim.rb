class AddConfirmationEmailRecipientsToClaim < ActiveRecord::Migration
  def change
    add_column :claims, :confirmation_email_recipients, :string, array: true, default: []
  end
end
