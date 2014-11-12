require 'rails_helper'

RSpec.describe AdditionalRespondentsForm, :type => :form do
  let(:attributes) do
    {
      has_additional_respondents: 'true',
      respondents_attributes: {
        "0" => {
          name: 'Butch McTaggert', acas_early_conciliation_certificate_number: '1',
          address_building: '1', address_street: 'High Street',
          address_locality: 'Anytown', address_county: 'Anyfordshire',
          address_post_code: 'W2 3ED'
        },
        "1" => {
          name: 'Pablo Noncer', acas_early_conciliation_certificate_number: '2',
          address_building: '2', address_street: 'Main Street',
          address_locality: 'Anycity', address_county: 'Anyford',
          address_post_code: 'W2 3ED'
        }
      }
    }
  end

  before do
    allow_any_instance_of(Respondent).to receive :enqueue_fee_group_reference_request
  end

  let(:claim) { Claim.create }

  subject { described_class.new(claim) }

  describe '#respondents_attributes=' do
    before do
      allow(claim.secondary_respondents).to receive(:build).and_return *respondents
      allow(claim.secondary_respondents).to receive(:empty?).and_return true, false
    end

    let(:respondents) { [Respondent.new, Respondent.new] }

    it 'builds new respondents and decorates them as AdditionalRespondents' do
      subject.assign_attributes attributes

      subject.respondents.each_with_index do |c, i|
        attributes[:respondents_attributes].values[i].each do |key, value|
          expect(c.send key).to eq value
        end

        expect(subject.respondents[i].target).to eq respondents[i]
      end
    end
  end

  describe '#respondents' do
    before { respondent }

    let(:respondent) { claim.secondary_respondents.build }
    let(:form)     { subject.respondents.first }

    it 'decorates any secondary respondents in an AdditionalRespondent' do
      expect(subject.respondents.length).to be 1
      expect(form).to be_a Form
      expect(form.target).to eq respondent
    end
  end

  describe '#errors' do
    before { 3.times { claim.respondents.create } }

    it 'maps the errors of #respondents' do
      expect(subject.errors[:respondents]).to include *subject.respondents.map(&:errors)
    end
  end

  describe '#save' do
    context 'when there are no secondary respondents' do
      it 'creates the secondary respondents' do
        subject.assign_attributes attributes
        subject.save
        claim.secondary_respondents.reload

        attributes[:respondents_attributes].each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_respondents[index].send(k)).to eq v }
        end
      end
    end

    context 'when there are existing secondary respondents' do
      before do
        2.times { claim.secondary_respondents.create }
      end

      it 'updates the secondary respondents' do
        subject.assign_attributes attributes
        subject.save
        claim.secondary_respondents.reload

        attributes[:respondents_attributes].each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_respondents[index].send(k)).to eq v }
        end
      end
    end

    context 'when all #respondents are valid' do
      before do
        subject.assign_attributes attributes
      end

      it 'returns true' do
        expect(subject.save).to be true
      end
    end

    context 'when some #respondents are not valid' do
      before { subject.has_additional_respondents = 'true' }

      it 'returns false' do
        expect(subject.save).to be false
      end
    end
  end
end
