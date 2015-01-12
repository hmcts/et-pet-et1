module JaduXml
  class ReceiptPresenter < XmlPresenter
    property :payment_service_provider, as: "PSP", exec_context: :decorator
    property :reference, as: "PayId"
    property :amount, as: "Amount"
    property :date, as: "Date", exec_context: :decorator

    delegate :created_at, to: :represented

    def payment_service_provider
      "Barclaycard"
    end

    def date
      created_at.xmlschema
    end
  end
end
