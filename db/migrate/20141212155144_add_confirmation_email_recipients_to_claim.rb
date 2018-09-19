class AddConfirmationEmailRecipientsToClaim < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :confirmation_email_recipients, :string, array: true, default: []
  end
end
