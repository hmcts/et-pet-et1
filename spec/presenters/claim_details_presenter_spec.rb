require 'rails_helper'

RSpec.describe ClaimDetailsPresenter, type: :presenter do
  subject { described_class.new claim_detail }

  let(:claim_detail) do
    double 'claim_detail',
      is_unfair_dismissal: true, discrimination_claims: [:sex_including_equal_pay, :race, :sexual_orientation],
      pay_claims: [:redundancy, :other], other_claim_details: "yo\r\nyo",
      claim_details: "wut\r\nwut",
      other_known_claimant_names: "Johnny Wishbone\r\nSamuel Pepys",
      is_whistleblowing: true, send_claim_to_whistleblowing_entity: false,
      miscellaneous_information: "hey\r\nhey"
  end

  its(:claim_details) { is_expected.to eq("<p>wut\n<br />wut</p>") }

  its(:other_known_claimant_names) do
    is_expected.to eq("<p>Johnny Wishbone\n<br />Samuel Pepys</p>")
  end
end
