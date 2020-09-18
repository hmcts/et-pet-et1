class AddAllowVideoAttendanceToClaimants < ActiveRecord::Migration[6.0]
  def change
    add_column :claimants, :allow_video_attendance, :boolean, null: true
  end
end
