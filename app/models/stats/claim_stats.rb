module Stats
  class ClaimStats < Claim
    MAXIMUM_DAYS_TO_SUBMIT_CLAIM = 91.days.freeze

    scope :started_within_max_submission_timeframe, lambda {
      where.not(state: 'submitted').
        progressed_from_application_reference_page.
        within_max_submission_timeframe
    }

    scope :completed_within_max_submission_timeframe,
          -> { where(state: 'submitted').within_max_submission_timeframe }

    scope :progressed_from_application_reference_page,
          -> { joins(:user).where.not(users: { id: nil }) }

    scope :within_max_submission_timeframe,
          -> { where('claims.created_at >= ?', MAXIMUM_DAYS_TO_SUBMIT_CLAIM.ago.to_date) }

    def self.started_count
      started_within_max_submission_timeframe.count
    end

    def self.completed_count
      completed_within_max_submission_timeframe.count
    end
  end
end
