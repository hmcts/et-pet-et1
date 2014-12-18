require 'rails_helper'

RSpec.describe AdditionalInformationPresenter, type: :presenter do
  let(:claim) { create :claim, miscellaneous_information: "hey\r\nhey" }

  subject { described_class.new claim }

  its(:miscellaneous_information) { is_expected.to eq("<p>hey\n<br />hey</p>") }
  its(:attached_document)         { is_expected.to eq('file.rtf') }
end
