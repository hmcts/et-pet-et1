module AddressPresenter
  COMPONENTS = %i<building street locality county post_code>.freeze

  def present(obj, prefix: nil)
    buffer = COMPONENTS.each_with_object([]) do |sym, buffer|
      component = obj.send key(attribute: sym, prefix: prefix)

      if component.present?
        buffer << obj.sanitize(component)
      else
        next
      end
    end
    buffer.join('<br>').html_safe
  end

  private def key(attribute:, prefix:)
    if prefix
      "#{prefix}_address_#{attribute}"
    else
      "address_#{attribute}"
    end
  end

  extend self
end
