require 'rails_helper'

RSpec.describe Respondent, type: :model do
  it { is_expected.to belong_to(:claim).optional }
  it { is_expected.to have_many(:addresses).autosave true }

  it_behaves_like "it has an address", :address
  it_behaves_like "it has an address", :work_address

  let(:claim) { Claim.new }
  let(:respondent) { described_class.new claim: claim }

  describe '#address' do
    specify { expect(respondent.address).to be_primary }
  end

  describe '#work_address' do
    specify { expect(respondent.work_address).not_to be_primary }
  end
end
