require 'rails_helper'

RSpec.describe Diversity, type: :model do
  let(:diversity) { Diversity.new(religion: 'describe') }

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
end
