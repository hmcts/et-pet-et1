require 'rails_helper'

RSpec.describe PdfForm::ClaimPresenter, type: :presenter do
  let(:claim) { claims(:full_claim)  }
  subject { described_class.new(claim) }
  let(:example_pdf_path) { 'spec/support/et1_pdf_example_all_fields.yml' }
  let(:hash) { subject.to_h }

  context 'full claim' do
    fixtures :all

    describe '#to_h' do
      it 'returns a complete hash of the claim ready for filling in the PDF form' do
        expect(hash).to eq(YAML.load(File.read(example_pdf_path)))
      end
    end
  end

  describe '#to_h' do
    context 'when owed' do
      %i<notice holiday arrears other>.each do |type|
        let(:claim) { Claim.new pay_claims: [type] }

        it "returns true when '#{type}' pay complaint" do
          expect(hash).to include('8.1 owed' => 'yes')
        end
      end
    end

    context 'when redundancy' do
      let(:claim) { Claim.new pay_claims: ['redundancy'] }
      it "returns false when 'redundancy' pay complaint" do
        expect(hash).to include('8.1 owed' => 'Off')
      end
    end
  end
end
