module AddressPresenter
  COMPONENTS = %i[building street locality county post_code].freeze

  def present(obj, prefix: nil)
    COMPONENTS.map do |sym|
      line = obj.send key(attribute: sym, prefix: prefix)
      next if line.blank?
      line + '<br />'
    end.compact.join
  end

  private

  def key(attribute:, prefix:)
    if prefix
      "#{prefix}_address_#{attribute}"
    else
      "address_#{attribute}"
    end
  end

  module_function :present, :key
end
