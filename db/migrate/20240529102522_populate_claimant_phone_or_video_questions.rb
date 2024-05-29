class PopulateClaimantPhoneOrVideoQuestions < ActiveRecord::Migration[7.1]
  class Claimant < ActiveRecord::Base
    self.table_name = :claimants
  end

  def up
    Claimant.where(allow_video_attendance: false).update_all(allow_phone_or_video_attendance: ['neither'])
    Claimant.where(allow_video_attendance: true).update_all(allow_phone_or_video_attendance: ['video'])
  end

  def down
    # Intentionally do nothing
  end
end
