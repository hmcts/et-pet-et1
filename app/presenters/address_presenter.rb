module AddressPresenter
  def present(obj)
    obj.instance_eval do
      components = [address_building, address_street, address_locality, address_county, address_post_code]
      components.reject(&:blank?).map { |s| sanitize s }.join('<br>').html_safe
    end
  end

  extend self
end
