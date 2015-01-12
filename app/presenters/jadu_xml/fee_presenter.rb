module JaduXml
  class FeePresenter < XmlPresenter
    property :amount, as: "Amount", exec_context: :decorator
    property :fee_group_reference, as: "PRN"
    property :date, as: "Date", exec_context: :decorator

    delegate :submitted_at, :fee_calculation, :fee_group_reference, to: :represented
    delegate :application_fee, to: :fee_calculation

    def amount
      application_fee
    end

    def date
      submitted_at.xmlschema
    end
  end
end
