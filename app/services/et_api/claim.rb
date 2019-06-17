class EtApi
  class Claim < Base
    def self.call(claim, uuid: SecureRandom.uuid, base_url: ENV.fetch('ET_API_URL'), json_parser: JSON, autosave: false)
      new(base_url: base_url, json_parser: json_parser).call(claim, uuid: uuid, autosave: autosave)
    end

    def call(claim, uuid: SecureRandom.uuid, autosave: false)
      claim.submitted_at = Time.zone.now
      json = ApplicationController.render 'api/claim/create_claim.json.jbuilder', locals: {
        claim: claim, office: claim.office, employment: claim.employment, uuid: uuid
      }
      response = send_request(json, path: '/claims/build_claim', subject: 'claim')
      update_claim claim, **json_parser.parse(response.body).dig('meta', 'BuildClaim').symbolize_keys
      claim.save if autosave
    end

    private

    def update_claim(claim, reference:, office:, pdf_url:)
      claim.fee_group_reference = reference
      claim.stored_pdf_url = pdf_url
      claim.build_office(office)
      claim.state = 'submitted'
    end
  end
end
