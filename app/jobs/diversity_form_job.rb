class DiversityFormJob < ActiveJob::Base
  queue_as :diversity_form

  def perform(diversity_id, uuid)
    @diversity_id = diversity_id
    @uuid = uuid
    Rails.logger.info "Starting DiversityFormJob"
    send_data_to_et_api
    Rails.logger.info "Finished DiversityFormJob"
  end

  private

  def send_data_to_et_api
    dde = DiversityDataExport.new(@diversity_id, @uuid)
    response = dde.send_data
    parse_response(response)
  end

  def parse_response(response)
    response.raise_for_status
  end
end
