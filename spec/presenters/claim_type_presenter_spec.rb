require 'rails_helper'

RSpec.describe ClaimTypePresenter, type: :presenter do
  subject { described_class.new claim_detail }

  let(:claim_detail) do
    double 'claim_detail',
      is_unfair_dismissal: true, discrimination_claims: [:sex_including_equal_pay, :race, :sexual_orientation],
      pay_claims: [:redundancy, :other], other_claim_details: "yo\r\nyo",
      is_whistleblowing: true, send_claim_to_whistleblowing_entity: false
  end

  def translation_for(option, section: 'options', br: true)
    I18n.t("simple_form.#{section}.claim_type.#{option}") + (br ? '<br />' : '')
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

  its(:is_whistleblowing) { is_expected.to eq("Yes") }
  its(:send_claim_to_whistleblowing_entity) { is_expected.to eq("No") }
end
