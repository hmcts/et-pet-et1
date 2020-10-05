class MigrateSavedClaimsAgain < ActiveRecord::Migration[6.0]
  class Claim < ::ActiveRecord::Base
    self.table_name = :claims
  end

  class User < ::ActiveRecord::Base
    self.table_name = :users
  end

  def up
    Claim.joins('LEFT OUTER JOIN users ON users.reference=claims.application_reference').where.not(password_digest: nil).where(state: 'created').where('users.id IS NULL').all.each do |claim|
      User.create email:claim.email_address || '', encrypted_password: claim.password_digest, reference: claim.application_reference
    end
  end

  def down
    # We cannot go back from this, there is no point
  end
end
