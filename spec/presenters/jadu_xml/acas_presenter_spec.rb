require 'rails_helper'

RSpec.describe JaduXml::AcasPresenter, type: :presenter do
  let(:jadu_xml_acas_presenter) { described_class.new respondent }

  let(:respondent) { Respondent.new }

  describe "delegated methods" do
    it { expect(jadu_xml_acas_presenter).to delegate_method(:acas_early_conciliation_certificate_number).to(:represented) }
    it { expect(jadu_xml_acas_presenter).to delegate_method(:no_acas_number_reason).to(:represented) }
  end

  describe "#exemption_code" do
    it 'maps all exemption types' do
      RespondentForm::NO_ACAS_REASON.each do |reason|
        mock_acas_reason(reason)
        expect(jadu_xml_acas_presenter.exemption_code).to be_present
      end
    end

    context "respondents no acas number reason returns" do
      context "joint_claimant_has_acas_number" do
        before { mock_acas_reason("joint_claimant_has_acas_number") }
        it { expect(jadu_xml_acas_presenter.exemption_code).to eq "other_claimant" }
      end

      context "acas_has_no_jurisdiction" do
        before { mock_acas_reason("acas_has_no_jurisdiction") }
        it { expect(jadu_xml_acas_presenter.exemption_code).to eq "outside_acas" }
      end

      context "employer_contacted_acas" do
        before { mock_acas_reason("employer_contacted_acas") }
        it { expect(jadu_xml_acas_presenter.exemption_code).to eq "employer_contacted_acas" }
      end

      context "interim_relief" do
        before { mock_acas_reason("interim_relief") }
        it { expect(jadu_xml_acas_presenter.exemption_code).to eq "interim_relief" }
      end

      context "an unknown acas reason code" do
        context "claim_against_security_services" do
          before { mock_acas_reason("claim_against_security_services") }
          it { expect(jadu_xml_acas_presenter.exemption_code).to be_nil }
        end
      end
    end
  end

  def mock_acas_reason(reason)
    allow(respondent).to receive(:no_acas_number_reason).and_return(reason)
  end
end
