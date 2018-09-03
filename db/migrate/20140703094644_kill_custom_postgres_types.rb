class KillCustomPostgresTypes < ActiveRecord::Migration[4.2]
  def change
    execute "DROP TYPE gender CASCADE;"
    execute "DROP TYPE contact_preference CASCADE;"
    execute "DROP TYPE person_title CASCADE;"

    add_column :claimants, :gender, :string
    add_column :claimants, :contact_preference, :string
    add_column :claimants, :title, :string
  end
end
