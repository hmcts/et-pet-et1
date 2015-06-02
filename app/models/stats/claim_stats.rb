module Stats
  class ClaimStats < Claim
    scope :submitted,         -> { where(state: 'submitted') }
    scope :within_timeframe,  -> { where('created_at > ?', 91.days.ago) }

    scope :started,
      -> { where.not(password_digest: nil, state: 'submitted').within_timeframe }
    scope :completed, -> { submitted.within_timeframe }
    scope :paid,
      -> { includes(:payment).submitted.where.not('payments.claim_id' => nil) }
    scope :remission,
      -> { includes(:payment).submitted.where('payments.claim_id' => nil) }

    scope :started_count,   -> { started.count }
    scope :completed_count, -> { completed.count }
    scope :paid_count,      -> { paid.count }
    scope :remission_count, -> { remission.count }
  end
end
