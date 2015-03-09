require 'rails_helper'

RSpec.describe ClaimDetailsPresenter, type: :presenter do
  subject { described_class.new claim }

  let(:claim) do
    create :claim,
      claim_details: "wut\r\nwut",
      other_known_claimant_names: "Johnny Wishbone\r\nSamuel Pepys"
  end

  its(:claim_details) { is_expected.to eq("<p>wut\n<br />wut</p>") }

  its(:other_known_claimant_names) do
    is_expected.to eq("<p>Johnny Wishbone\n<br />Samuel Pepys</p>")
  end

  its(:attached_document) { is_expected.to eq('file.rtf') }
end
