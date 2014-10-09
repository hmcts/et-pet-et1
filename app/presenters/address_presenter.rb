module AddressPresenter
  COMPONENTS = %i<building street locality county post_code>.freeze

  def present(obj)
    buffer = COMPONENTS.each_with_object([]) do |sym, buffer|
      component = obj.send "address_#{sym}"

      if component.present?
        buffer << obj.sanitize(component)
      else
        next
      end
    end

    buffer.join('<br>').html_safe
  end

  extend self
end
