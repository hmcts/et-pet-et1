module Refunds
  class ConfirmationForm < Form
    attribute :application_reference, :string
    attribute :submitted_at, :gds_date_type

    def initialize(resource, &block)
      raise 'Session has no persisted refund' unless resource.respond_to?('_refund_id')
      super(Refund.find_by!(id: resource._refund_id), &block)
    end
  end
end
