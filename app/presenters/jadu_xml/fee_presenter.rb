module JaduXml
  class FeePresenter < XmlPresenter
    property :amount, as: "Amount"
    property :fee_group_reference, as: "PRN"
    property :date, as: "Date"
  end
end
