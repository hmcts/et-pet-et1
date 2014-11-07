module JaduXml
  class AcasPresenter < XmlPresenter
    property :acas_early_conciliation_certificate_number, as: "Number", render_nil: true
    property :exemption_code, as: "ExemptionCode"
  end
end
