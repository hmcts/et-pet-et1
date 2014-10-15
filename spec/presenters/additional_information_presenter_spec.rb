require 'rails_helper'

RSpec.describe AdditionalInformationPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) do
    Claim.new miscellaneous_information: "hey\r\nhey"
  end

  its(:miscellaneous_information) { is_expected.to eq("<p>hey\n<br />hey</p>") }

  describe '#attached_document' do
    before { allow(claim.attachment).to receive(:filename).and_return 'lolz.rtf' }

    specify { expect(subject.attached_document).to eq('lolz.rtf') }
  end
end
