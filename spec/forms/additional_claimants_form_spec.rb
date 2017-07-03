require 'rails_helper'

RSpec.describe AdditionalClaimantsForm, :type => :form do
  let(:attributes) do
    {
      of_collection_type: 'true',
      collection_attributes: {
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
      allow(claim.secondary_claimants).to receive(:build).and_return *collection
      allow(claim.secondary_claimants).to receive(:empty?).and_return true, false
    end

    let(:collection) { [Claimant.new, Claimant.new] }

    it 'builds new claimants and decorates them as AdditionalClaimants' do
      subject.assign_attributes attributes

      subject.collection.each_with_index do |c, i|
        attributes[:collection_attributes].values[i].each do |key, value|
          expect(c.send key).to eq value
        end

        expect(subject.collection[i].target).to eq collection[i]
      end
    end
  end

  describe '#claimants' do
    before { claimant }

    let(:claimant) { claim.secondary_claimants.build }
    let(:form)     { subject.collection.first }

    it 'decorates any secondary claimants in an AdditionalClaimant' do
      expect(subject.collection.length).to be 1
      expect(form).to be_a Form
      expect(form.target).to eq claimant
    end
  end

  describe '#errors' do
    before { 3.times { claim.secondary_claimants.create } }

    it 'maps the errors of #claimants' do
      expect(subject.errors[:collection]).to include *subject.collection.map(&:errors)
    end
  end

  describe '#save' do
    context 'when there are no secondary claimants' do
      it 'creates the secondary claimants' do
        subject.assign_attributes attributes
        subject.save
        claim.secondary_claimants.reload

        attributes[:collection_attributes].each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_claimants[index].send(k)).to eq v }
        end
      end
    end

    context 'when there are existing secondary claimants' do
      before do
        2.times { claim.secondary_claimants.create }
        subject.assign_attributes attributes
        subject.save
      end

      it 'updates the secondary claimants' do
        claim.secondary_claimants.reload
        expect(claim.secondary_claimants.count).to eql(2)

        attributes[:collection_attributes].each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_claimants[index].send(k)).to eq v }
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
      before { subject.of_collection_type = 'true' }

      it 'returns false' do
        expect(subject.save).to be false
      end
    end
  end
end
