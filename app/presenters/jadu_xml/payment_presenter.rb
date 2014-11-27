module JaduXml
  class PaymentPresenter < XmlPresenter
    # FIXME: Hack alert! Beep Beep
    property :fee, as: "Fee", extend: JaduXml::FeePresenter
  end
end
