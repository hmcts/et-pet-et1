class AddAdminUserWithRandomPassword < ActiveRecord::Migration[7.1]
  def up
    return unless Object.const_defined?('AdminUser')

    password = SecureRandom.hex(16)
    admin_user = AdminUser.find_or_initialize_by(email: 'daniel.thompson@justice.gov.uk')
    if admin_user.new_record?
      admin_user.password = password
      admin_user.password_confirmation = password
      admin_user.save!
    end
  end

  def down
    return unless Object.const_defined?('AdminUser')

    admin_user = AdminUser.find_by(email: 'daniel.thompson@justice.gov.uk')
    admin_user&.destroy!
  end
end
