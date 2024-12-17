module Refunds
  class ConfirmationForm < Form
    attribute :application_reference, :string
    attribute :submitted_at, :et_date

    def initialize(resource, &form)
      raise 'Session has no persisted refund' unless resource.respond_to?('_refund_id')

      super(Refund.find_by!(id: resource._refund_id), &form)
    end
  end
end
