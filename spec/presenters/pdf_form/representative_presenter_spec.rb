require 'rails_helper'

RSpec.describe PdfForm::RepresentativePresenter, type: :presenter do
  subject { described_class.new(representative) }
  let(:hash) { subject.to_h }

  describe '#to_h' do
    it_behaves_like 'it includes a formatted postcode', Representative, '11.3'
    it_behaves_like 'it includes a contact preference', Representative, '11.9'
  end
end
