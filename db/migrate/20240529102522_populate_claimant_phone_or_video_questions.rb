class PopulateClaimantPhoneOrVideoQuestions < ActiveRecord::Migration[7.1]
  class Claimant < ActiveRecord::Base
    self.table_name = :claimants
  end

  def up
    Claimant.where(allow_video_attendance: false).all.each do |claimants|
      claimant.update(allow_phone_or_video_attendance: ['neither'])
    end
    Claimant.where(allow_video_attendance: true).all.each do |claimant|
      claimant.update(allow_phone_or_video_attendance: ['video'])
    end
  end

  def down
    # Intentionally do nothing
  end
end
