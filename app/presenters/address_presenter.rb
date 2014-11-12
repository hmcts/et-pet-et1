module AddressPresenter
  COMPONENTS = %i<building street locality county post_code>.freeze

  def present(obj)
    buffer = []
    COMPONENTS.each do |sym|
      component = obj.send("address_#{sym}")
      buffer << obj.sanitize(component) if component.present?
    end
    buffer.join('<br>').html_safe
  end

  extend self
end
