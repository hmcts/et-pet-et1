require 'rails_helper'

RSpec.describe AdditionalInformationPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) do
    create :claim, miscellaneous_information: "hey\r\nhey"
  end

  its(:miscellaneous_information) { is_expected.to eq("<p>hey\n<br />hey</p>") }
end
