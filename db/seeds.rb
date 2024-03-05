admin_user = AdminUser.find_or_initialize_by(email: 'admin@example.com')
if admin_user.new_record?
  admin_user.password = 'password'
  admin_user.password_confirmation = 'password'
  admin_user.save!
end
