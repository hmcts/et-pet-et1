module Diversities
  class ConfirmationForm < Form
    def initialize(resource, &)
      raise 'Session has no persisted refund' unless resource.respond_to?('_diversity_id')

      super(Diversity.find_by!(id: resource._diversity_id), &)
    end
  end
end
