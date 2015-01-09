require 'rails_helper'

RSpec.describe JaduXml::AcasPresenter, type: :presenter do
  let(:respondent) { Respondent.new }
  subject { described_class.new respondent }

  describe "delegated methods" do
    it { is_expected.to delegate_method(:acas_early_conciliation_certificate_number).to(:represented) }
    it { is_expected.to delegate_method(:no_acas_number_reason).to(:represented) }
  end

  describe "#exemption_code" do
    context "respondents no acas number reason returns" do
      context "joint_claimant_has_acas_number" do
        before { mock_acas_reason("joint_claimant_has_acas_number") }
        its(:exemption_code) { is_expected.to eq "other_claimant" }
      end

      context "acas_has_no_jurisdiction" do
        before { mock_acas_reason("acas_has_no_jurisdiction") }
        its(:exemption_code) { is_expected.to eq "outside_acas" }
      end

      context "employer_contacted_acas" do
        before { mock_acas_reason("employer_contacted_acas") }
        its(:exemption_code) { is_expected.to eq "employer_contacted_acas" }
      end

      context "interim_relief" do
        before { mock_acas_reason("interim_relief") }
        its(:exemption_code) { is_expected.to eq "interim_relief" }
      end

      context "claim_against_security_or_intelligence_services" do
        before { mock_acas_reason("claim_against_security_or_intelligence_services") }
        its(:exemption_code) { is_expected.to eq "claim_targets" }
      end
    end
  end

  def mock_acas_reason(reason)
    allow(respondent).to receive(:no_acas_number_reason).and_return(reason)
  end
end
