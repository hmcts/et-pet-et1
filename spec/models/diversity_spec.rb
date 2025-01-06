require 'rails_helper'

RSpec.describe Diversity, type: :model do
  let(:diversity) { build(:diversity, religion: 'describe') }
  let(:uuid) { '246b26b3-e383-4b68-b5b7-6d4ed6c76093' }

  shared_context 'with transactions off' do
    around do |example|
      old = use_transactional_tests
      self.use_transactional_tests = false
      example.run
      self.use_transactional_tests = old
    end
  end

  describe '#fill_religion' do
    it 'save the free text value if present' do
      diversity.religion_text = 'Jedi'
      diversity.save
      expect(diversity.reload.religion).to eql('Jedi')
    end

    it 'keep the religion value' do
      diversity.religion_text = ''
      diversity.save
      expect(diversity.reload.religion).to eql('describe')
    end
  end

  describe 'send_the_data to ET API', :clean_with_truncation do
    include_context 'with transactions off'
    before do
      allow(SecureRandom).to receive(:uuid).and_return uuid
    end

    it "after create" do
      expect(DiversityFormJob).to receive(:perform_later).with(diversity, uuid)
      diversity.save
    end

    it "not after save" do
      diversity.save
      expect(DiversityFormJob).not_to receive(:perform_later)
      diversity.religion = 'test'
      diversity.save
    end
  end
end
