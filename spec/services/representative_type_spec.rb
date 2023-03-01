require 'rails_helper'

RSpec.describe RepresentativeType, type: :service do
  type_mappings = {
    'citizen_advice_bureau' => 'CAB',
    'free_representation_unit' => 'FRU',
    'law_centre' => 'Law Centre',
    'trade_union' => 'Union',
    'solicitor' => 'Solicitor',
    'private_individual' => 'Private Individual',
    'trade_association' => 'Trade Association',
    'other' => 'Other'
  }

  describe '::TYPES' do
    specify { expect(described_class::TYPES).to match_array type_mappings.keys }
  end

  describe '.convert_for_jadu' do
    type_mappings.each do |key, mapping|
      it "maps #{key} to #{mapping}" do
        expect(described_class.convert_for_jadu(key)).to eq mapping
      end
    end
  end
end
