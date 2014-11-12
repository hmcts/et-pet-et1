module AddressPresenter
  COMPONENTS = %i<building street locality county post_code>.freeze

  def present(obj, prefix: nil)
    COMPONENTS.each_with_object(ActiveSupport::SafeBuffer.new) do |sym, buffer|
      component = obj.send key(attribute: sym, prefix: prefix)

      if component.present?
        buffer << component << '<br>'.html_safe
      else
        next
      end
    end
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
