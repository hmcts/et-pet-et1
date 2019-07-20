require 'webmock/cucumber'
require_relative './capybara_driver_helper'
selenium_url = URI.parse ENV.fetch('SELENIUM_URL', 'http://localhost:4444/wd/hub')
app_host_url = URI.parse Capybara.app_host
et_api_url = 'http://api.et.net:4000/api/v2'
build_claim_url = "#{et_api_url}/claims/build_claim"
create_reference_url =  "#{et_api_url}/references/create_reference"
WebMock.disable_net_connect!(allow_localhost: true, allow: [selenium_url.host, app_host_url.host])
Around('@mock_et_api') do |_scenario, block|
  ClimateControl.modify ET_API_URL: et_api_url do
    stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return(body: '{}', status: 202, headers: { 'Content-Type': 'application/json' })
    stub_request(:post, create_reference_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return(body: { status: 'created', data: { reference: 'somereference', office: { code: 11, name: 'Puddletown', address: '1 Some road, Puddletown', telephone: '020 1234 5678', email: 'office@email.com' }} }.to_json, status: 201, headers: { 'Content-Type': 'application/json' })
    block.call
  end
end
