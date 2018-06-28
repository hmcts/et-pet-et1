module Diversities
  class ConfirmationForm < Form
    attribute :application_reference, String
    attribute :submitted_at, Date

    def initialize(resource, &block)
      raise 'Session has no persisted refund' unless resource.respond_to?('_diversity_id')
      super(Diversity.find_by!(id: resource._diversity_id), &block)
    end
  end
end
