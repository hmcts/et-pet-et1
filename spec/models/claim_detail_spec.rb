require 'rails_helper'

RSpec.describe ClaimDetail, :type => :model do
  it { is_expected.to belong_to :claim }

  describe 'bitmasked attributes' do
    let(:subject) { ClaimDetail.new }

    %i<discrimination_claims pay_claims desired_outcomes>.each do |attr|
      specify { expect(subject.send attr).to be_an(Array) }
    end
  end
end
