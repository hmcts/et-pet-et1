module JaduXml
  class Payment < Struct.new(:claim)
    delegate :fee_calculation, :fee_group_reference, :submitted_at, to: :claim
    delegate :application_fee_after_remission, to: :fee_calculation

    def fee
      self
    end

    def amount
      application_fee_after_remission
    end

    def date
      submitted_at.xmlschema
    end
  end
end
