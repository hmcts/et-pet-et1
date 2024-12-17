require 'rails_helper'

RSpec.describe SubmitDiversityResponseToApiService, type: :service do
  shared_context 'with api environment variable' do
    let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
    around do |example|
      ClimateControl.modify ET_API_URL: et_api_url do
        example.run
      end
    end
  end

  shared_context 'with command matcher' do
    matcher :contain_valid_api_command do |expected_command|
      chain :version do |version|
        @version = version
      end
      chain :for_db_data do |db_data|
        @db_data = db_data
      end
      errors = []

      match do |actual|
        errors = []
        json = JSON.parse(actual.body).deep_symbolize_keys[:data].detect { |command| command[:command] == expected_command }
        expect(json).to be_a_valid_api_command(expected_command).version(@version).for_db_data(@db_data)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        errors << "Json did not contain valid api command for #{expected_command}"
        errors.concat(e.message.lines.map { |l| "#{'  ' * 2}#{l.gsub(/\n\z/, '')}" })
        false
      end

      failure_message do
        "Expected sent request body to be a valid api command for #{expected_command} but it wasn't\n\nThe errors reported were: #{errors.join("\n")}"

      end
    end
    matcher :contain_api_command do |expected_command|
      match do |actual|
        JSON.parse(actual.body).deep_symbolize_keys[:data].any? { |command| command[:command] == expected_command }
      end
    end
  end

  describe '.call' do

    let(:build_diversity_response_url) { "#{et_api_url}/diversity/build_diversity_response" }

    shared_context 'with build diversity response endpoint recording' do
      my_request = nil
      subject(:recorded_request) { JSON.parse(my_request.body).deep_symbolize_keys }

      before do
        my_request = nil
        stub_request(:post, build_diversity_response_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
          my_request = request
          { body: '{}', headers: { 'Content-Type': 'application/json' } }
        end
      end
    end

    shared_context 'with action performed before each example' do
      before do
        described_class.call example_diversity_response
      end
    end

    include_context 'with api environment variable'
    include_context 'with build diversity response endpoint recording'
    include_context 'with command matcher'
    context 'with typical data set' do
      let(:example_diversity_response) { create(:diversity) }

      include_context 'with action performed before each example'
      it { is_expected.to be_a_valid_api_command('BuildDiversityResponse').version(2).for_db_data(example_diversity_response) }
    end
  end
end
