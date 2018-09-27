module EtApi
  def self.create_claim(claim, api_base: ENV.fetch('ET_API_URL'))
    json = ApplicationController.render 'api/claim/create_claim.json.jbuilder', locals: {
      claim: claim, office: claim.office, employment: claim.employment
    }
    Rails.logger.info "Sent claim to API at #{api_base}/claims/build_claim - json was #{JSON.pretty_generate(JSON.parse(json))}"

    response = HTTParty.post("#{api_base}/claims/build_claim", body: json, headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' })

  end
end
