require 'rails_helper'

RSpec.describe AdditionalClaimantsForm, type: :form do
  let(:additional_claimants_form) { described_class.new(claim) }

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

  describe '#claimants_attributes=' do
    before do
      allow(claim.secondary_claimants).to receive(:build).and_return(*collection)
      allow(claim.secondary_claimants).to receive(:empty?).and_return true, false
      additional_claimants_form.assign_attributes attributes
    end

    let(:collection) { [Claimant.new, Claimant.new] }

    it 'builds new claimants with attributes' do
      additional_claimants_form.collection.each_with_index do |c, i|
        attributes[:collection_attributes].values[i].each do |key, value|
          expect(c.send(key)).to eq value
        end
      end
    end

    it 'decorates AdditionalClaimants as Claimants' do
      additional_claimants_form.collection.each_with_index do |_c, i|
        expect(additional_claimants_form.collection[i].target).to eq collection[i]
      end
    end
  end

  describe '#claimants' do
    before { claimant }

    let(:claimant) { claim.secondary_claimants.build }
    let(:form)     { additional_claimants_form.collection.first }

    describe 'decorates any secondary claimants in an AdditionalClaimant' do
      it { expect(additional_claimants_form.collection.length).to be 1 }
      it { expect(form).to be_a Form }
      it { expect(form.target).to eq claimant }
    end
  end

  describe '#errors' do
    before { 3.times { claim.secondary_claimants.create } }

    it 'maps the errors of #claimants' do
      expect(additional_claimants_form.errors[:collection]).to include(*additional_claimants_form.collection.map(&:errors))
    end
  end

  describe '#save' do
    context 'when there are no secondary claimants' do
      it 'creates the secondary claimants' do
        additional_claimants_form.assign_attributes attributes
        additional_claimants_form.save
        claim.secondary_claimants.reload

        attributes[:collection_attributes].sort.each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_claimants[index].send(k)).to eq v }
        end
      end
    end

    context 'when there are existing secondary claimants' do
      before do
        2.times { claim.secondary_claimants.create }
        additional_claimants_form.assign_attributes attributes
        additional_claimants_form.save
        claim.secondary_claimants.reload
      end

      it 'has 2 secondary claimants' do
        expect(claim.secondary_claimants.count).to be(2)
      end

      it 'updates the secondary claimants attributes' do
        attributes[:collection_attributes].sort.each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_claimants[index].send(k)).to eq v }
        end
      end
    end

    context 'when all #claimants are valid' do
      before do
        additional_claimants_form.assign_attributes attributes
      end

      it 'returns true' do
        expect(additional_claimants_form.save).to be true
      end
    end

    context 'when some #claimants are not valid' do
      before { additional_claimants_form.of_collection_type = 'true' }

      it 'returns false' do
        expect(additional_claimants_form.save).to be false
      end
    end
  end
end
