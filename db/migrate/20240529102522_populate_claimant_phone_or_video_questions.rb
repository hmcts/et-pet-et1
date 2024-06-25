class PopulateClaimantPhoneOrVideoQuestions < ActiveRecord::Migration[7.1]
  class Claimant < ActiveRecord::Base
    self.table_name = :claimants
  end

  def up
    execute <<-SQL
      UPDATE claimants
      SET allow_phone_or_video_attendance = '{neither}'::varchar[]
      WHERE allow_video_attendance = false
    SQL
    execute <<-SQL
      UPDATE claimants
      SET allow_phone_or_video_attendance = '{video}'::varchar[]
      WHERE allow_video_attendance = true
    SQL
  end

  def down
    execute <<-SQL
      UPDATE claimants
      SET allow_phone_or_video_attendance = '{}'::varchar[]
    SQL
  end
end
