class Jadu::PaymentSerializer < Jadu::BaseSerializer
  def to_xml(options={})
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.Payment do
      xml.Fee do
        xml.Amount amount
        xml.PRN reference
        xml.Date created_at.try(:xmlschema)
      end
    end
  end
end
