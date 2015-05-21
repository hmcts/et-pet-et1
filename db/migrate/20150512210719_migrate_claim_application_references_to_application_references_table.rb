class MigrateClaimApplicationReferencesToApplicationReferencesTable < ActiveRecord::Migration
  def up
    execute <<-SQL.strip_heredoc
      INSERT INTO "application_references"
        (reference, claim_id, created_at)
        SELECT application_reference, id, created_at
        FROM "claims"
    SQL

    remove_column :claims, :application_reference
  end

  def down
    add_column :claims, :application_reference, :string

    execute <<-SQL.strip_heredoc
      UPDATE "claims" c
        SET application_reference =
        (SELECT ar.reference
          FROM "application_references" ar
          WHERE c.id = ar.claim_id)
      ;
      TRUNCATE "application_references"
    SQL
  end
end
