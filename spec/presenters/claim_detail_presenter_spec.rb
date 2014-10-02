require 'rails_helper'

describe ClaimDetailPresenter do
  subject { ClaimDetailPresenter.new claim_detail }

  let(:claim_detail) do
    double 'claim_detail',
      is_unfair_dismissal: true, discrimination_claims: [:sex_including_equal_pay, :race, :sexual_orientation],
      pay_claims: [:redundancy, :other], other_claim_details: "yo\r\nyo",
      claim_details: "wut\r\nwut", desired_outcomes: [:tribunal_recommendation, :new_employment_and_compensation],
      other_outcome: "25 bags\r\nyour job",
      other_known_claimant_names: "Johnny Wishbone\r\nSamuel Pepys",
      is_whistleblowing: true, send_claim_to_whistleblowing_entity: false,
      miscellaneous_information: "hey\r\nhey"
  end

  def translation_for(option, section: 'options', br: true)
    I18n.t("simple_form.#{section}.claim.#{option}") + (br ? '<br />' : '')
  end

  describe '#types' do
    it 'concatenates is_unfair_dismissal, discrimination_claims, and pay_claims' do
      expect(subject.types).to eq(
        translation_for('is_unfair_dismissal', section: 'labels') +
        translation_for('pay_claims.redundancy') +
        translation_for('pay_claims.other') +
        translation_for('discrimination_claims.sex_including_equal_pay') +
        translation_for('discrimination_claims.race') +
        translation_for('discrimination_claims.sexual_orientation', br: false)
      )
    end
  end

  its(:claim_details) { is_expected.to eq("<p>wut\n<br />wut</p>") }

  its(:desired_outcomes) do
    is_expected.
      to eq "A recommendation from a tribunal (that the employer takes action so that the problem at work doesn’t happen again)" +
        "<br />To get another job with the same employer or associated employer, and compensation"
  end

  its(:other_outcome) { is_expected.to eq("<p>25 bags\n<br />your job</p>") }
  its(:other_known_claimant_names) do
    is_expected.to eq("<p>Johnny Wishbone\n<br />Samuel Pepys</p>")
  end

  its(:is_whistleblowing) { is_expected.to eq("Yes") }
  its(:send_claim_to_whistleblowing_entity) { is_expected.to eq("No") }
  its(:miscellaneous_information) { is_expected.to eq("<p>hey\n<br />hey</p>") }
end
