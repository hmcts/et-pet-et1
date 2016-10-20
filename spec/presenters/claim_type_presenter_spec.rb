require 'rails_helper'

RSpec.describe ClaimTypePresenter, type: :presenter do
  subject { described_class.new claim_detail }

  let(:claim_detail) do
    double 'claim_detail',
      is_unfair_dismissal: true, is_protective_award: false,
      discrimination_claims: [:sex_including_equal_pay, :race, :sexual_orientation],
      pay_claims: [:redundancy, :other], other_claim_details: "yo\r\nyo",
      is_whistleblowing: true, send_claim_to_whistleblowing_entity: false
  end

  def type_text(text, line_break: true)
    text + (line_break ? '<br />' : '')
  end

  describe '#types' do
    it 'concatenates is_unfair_dismissal, discrimination_claims, and pay_claims' do
      expect(subject.types).to eq(
        type_text('Unfair dismissal (including constructive dismissal)') +
        type_text('Protective Award') +
        type_text('Redundancy pay') +
        type_text('Other payments') +
        type_text('Sex (including equal pay) discrimination') +
        type_text('Race discrimination') +
        type_text('Sexual orientation discrimination', line_break: false)
      )
    end
  end

  its(:is_whistleblowing) { is_expected.to eq("Yes") }
  its(:send_claim_to_whistleblowing_entity) { is_expected.to eq("No") }
  its(:is_protective_award) { is_expected.to eq("No") }
end
