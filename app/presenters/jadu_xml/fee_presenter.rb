module JaduXml
  class FeePresenter < XmlPresenter
    property :amount, as: "Amount", exec_context: :decorator
    property :fee_group_reference, as: "PRN", render_nil: true
    property :date, as: "Date", exec_context: :decorator

    delegate :submitted_at, :fee_calculation, :fee_group_reference, to: :represented
    delegate :application_fee, to: :fee_calculation

    def amount
      # No fee need to be paid for all applications
      return 0
    end

    def date
      submitted_at.xmlschema
    end
  end
end
