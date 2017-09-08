require 'rails_helper'

RSpec.describe ClaimOutcomePresenter, type: :presenter do
  subject { described_class.new claim_detail }

  let(:claim_detail) do
    instance_double 'Claim',
      desired_outcomes: [:tribunal_recommendation, :new_employment_and_compensation],
      other_outcome: "25 bags\r\nyour job"
  end

  its(:desired_outcomes) do
    is_expected.
      to eq "A recommendation from a tribunal (that the employer takes action so that the problem at work doesn’t happen again)" \
            "<br />To get another job with the same employer or associated employer"
  end

  its(:other_outcome) { is_expected.to eq("<p>25 bags\n<br />your job</p>") }
end
