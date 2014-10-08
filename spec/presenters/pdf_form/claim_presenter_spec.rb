require 'rails_helper'

RSpec.describe PdfForm::ClaimPresenter, type: :presenter do
  subject { described_class.new(claim) }
  let(:hash) { subject.to_h }

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
