require 'rails_helper'

RSpec.describe AdditionalClaimantsForm, :type => :form do
  let(:attributes) do
    {
      has_additional_claimants: 'true',
      claimants_attributes: {
        "0" => {
          title: 'mr', first_name: 'Barrington', last_name: 'Wrigglesworth',
          address_building: '1', address_street: 'High Street',
          address_locality: 'Anytown', address_county: 'Anyfordshire',
          address_post_code: 'W2 3ED', date_of_birth: Date.civil(1995, 1, 1)
        },
        "1" => {
          title: 'mrs', first_name: 'Lollington', last_name: 'Wrigglesworth',
          address_building: '2', address_street: 'Main Street',
          address_locality: 'Anycity', address_county: 'Anyford',
          address_post_code: 'W2 3ED', date_of_birth: Date.civil(1995, 1, 1)
        }
      }
    }
  end

  let(:claim) { Claim.create }

  subject { described_class.new(claim) }

  describe '#claimants_attributes=' do
    before do
      allow(claim.secondary_claimants).to receive(:build).and_return *claimants
      allow(claim.secondary_claimants).to receive(:empty?).and_return true, false
    end

    let(:claimants) { [Claimant.new, Claimant.new] }

    it 'builds new claimants and decorates them as AdditionalClaimants' do
      subject.assign_attributes attributes

      subject.claimants.each_with_index do |c, i|
        attributes[:claimants_attributes].values[i].each do |key, value|
          expect(c.send key).to eq value
        end

        expect(subject.claimants[i].target).to eq claimants[i]
      end
    end
  end

  describe '#claimants' do
    before { claimant }

    let(:claimant) { claim.secondary_claimants.build }
    let(:form)     { subject.claimants.first }

    it 'decorates any secondary claimants in an AdditionalClaimant' do
      expect(subject.claimants.length).to be 1
      expect(form).to be_a Form
      expect(form.target).to eq claimant
    end
  end

  describe '#errors' do
    before { 3.times { claim.claimants.create } }

    it 'maps the errors of #claimants' do
      expect(subject.errors[:claimants]).to include *subject.claimants.map(&:errors)
    end
  end

  describe '#save' do
    context 'when there are no secondary claimants' do
      it 'creates the secondary claimants' do
        subject.assign_attributes attributes
        subject.save
        claim.secondary_claimants.reload

        attributes[:claimants_attributes].each_with_index do |(_, attributes), index|
          attributes.each { |k,v| expect(claim.secondary_claimants[index].send(k)).to eq v }
        end
      end
    end

    context 'when there are existing secondary claimants' do
      before do
        2.times { claim.secondary_claimants.create }
      end

      it 'updates the secondary claimants' do
        subject.assign_attributes attributes
        subject.save
        claim.secondary_claimants.reload

        attributes[:claimants_attributes].each_with_index do |(_, attributes), index|
          attributes.each { |k,v| expect(claim.secondary_claimants[index].send(k)).to eq v }
        end
      end
    end

    context 'when all #claimants are valid' do
      before do
        subject.assign_attributes attributes
      end

      it 'returns true' do
        expect(subject.save).to be true
      end
    end

    context 'when some #claimants are not valid' do
      before { subject.has_additional_claimants = 'true' }

      it 'returns false' do
        expect(subject.save).to be false
      end
    end
  end
end
