class AddAllowPhoneOrVideoAttendanceToClaimants < ActiveRecord::Migration[7.1]
  def change
    add_column :claimants, :allow_phone_or_video_attendance, :string, array: true, default: []
    add_column :claimants, :allow_phone_or_video_reason, :text
  end
end
