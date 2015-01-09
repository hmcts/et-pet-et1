module JaduXml
  class PaymentPresenter < XmlPresenter
    property :fee, as: "Fee",
      extend: JaduXml::FeePresenter,
      exec_context: :decorator

    property :receipt, as: "Receipt",
      extend: JaduXml::ReceiptPresenter,
      exec_context: :decorator

    def fee
      represented
    end

    def receipt
      represented.payment
    end
  end
end
