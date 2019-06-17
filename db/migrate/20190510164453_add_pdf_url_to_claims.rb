class AddPdfUrlToClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :stored_pdf_url, :string, null: true
  end
end
