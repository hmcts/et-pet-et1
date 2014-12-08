require 'rails_helper'

RSpec.describe AdditionalInformationPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) do
    Claim.new miscellaneous_information: "hey\r\nhey"
  end

  its(:miscellaneous_information) { is_expected.to eq("<p>hey\n<br />hey</p>") }

  describe '#attached_document' do
    before do
      allow(claim.additional_information_rtf).to receive(:to_s).
        and_return '/uploads/claim/additional_information_rtf/6CV34CSM70RK0E9G/lolz.rtf'
    end

    specify { expect(subject.attached_document).to eq('lolz.rtf') }
  end
end
