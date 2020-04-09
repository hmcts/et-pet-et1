class AddPdfUrlToClaims < ActiveRecord::Migration[6.0]
  def change
    add_column :claims, :pdf_url, :string
  end
end
