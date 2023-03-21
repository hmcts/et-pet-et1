class DiversityFormJob < ApplicationJob
  queue_as :diversity_form

  def perform(diversity, uuid)
    Rails.logger.info "Starting DiversityFormJob"

    EtApi.build_diversity_response diversity, uuid: uuid
    Rails.logger.info "Finished DiversityFormJob"
  end
end
