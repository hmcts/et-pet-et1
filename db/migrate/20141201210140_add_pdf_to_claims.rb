class AddPdfToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :pdf, :string
  end
end
