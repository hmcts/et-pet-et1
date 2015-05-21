module Stats
  class ClaimStats < Claim
    scope :started_claims,
      -> { where.not(password_digest: nil, state: 'submitted').within_timeframe }
    scope :completed_claims,
      -> { where(state: 'submitted').within_timeframe }
    scope :within_timeframe, -> { where('created_at > ?', 91.days.ago) }

    class << self
      def started_count
        started_claims.count
      end

      def completed_count
        completed_claims.count
      end
    end
  end
end
