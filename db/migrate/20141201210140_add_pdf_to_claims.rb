class AddPdfToClaims < ActiveRecord::Migration[4.2]
  def change
    add_column :claims, :pdf, :string
  end
end
