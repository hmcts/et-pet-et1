module RepresentativeType
  MAPPINGS = {
    'citizen_advice_bureau'    => 'CAB',
    'free_representation_unit' => 'FRU',
    'law_centre'               => 'Law Centre',
    'trade_union'              => 'Union',
    'solicitor'                => 'Solicitor',
    'private_individual'       => 'Private Individual',
    'trade_association'        => 'Trade Association',
    'other'                    => 'Other'
  }.freeze
  private_constant :MAPPINGS

  TYPES = MAPPINGS.keys.freeze

  def convert_for_jadu(type)
    MAPPINGS[type]
  end

  module_function :convert_for_jadu
end
