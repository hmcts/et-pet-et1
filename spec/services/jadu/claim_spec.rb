require 'rails_helper'

RSpec.describe Jadu::Claim, type: :service do
  include_context 'block pdf generation'

  let(:api_double) { instance_double Jadu::API }
  let(:endpoint)   { ENV.fetch('JADU_API').to_s }
  let(:xml)        { instance_double JaduXml::ClaimPresenter, to_xml: xml_double }
  let(:xml_double) { instance_double('XML', :xml) }
  let(:claim)      { create :claim }

  let(:successful_api_response) do
    Jadu::API::ParsedResponse.new \
      instance_double('HTTParty::Response', code: 200, body: { 'feeGroupReference' => '1234567890' }.to_json)
  end

  let(:failure_api_response) do
    Jadu::API::ParsedResponse.new \
      instance_double('HTTParty::Response', code: 400, body: { 'errorCode' => '1', 'errorDescription' => 'herp', 'details' => 'derp' }.to_json)
  end

  let(:attachments) do
    { "et1_barrington_wrigglesworth.pdf" => claim.pdf_file.read,
      "file.rtf" => claim.claim_details_rtf_file.read,
      "file.csv" => claim.additional_claimants_csv_file.read }
  end

  before do
    claim.generate_pdf!
    allow(Jadu::API).to receive(:new).with(endpoint).and_return api_double
    allow(JaduXml::ClaimPresenter).to receive(:new).with(claim).and_return xml
  end

  describe '.create' do
    it 'submits a claim to Jadu' do
      expect(api_double).to receive(:new_claim).
        with(xml_double, attachments).and_return successful_api_response

      Jadu::Claim.create claim
    end

    it 'creates a log event' do
      allow(api_double).to receive(:new_claim).
        with(xml_double, attachments).and_return successful_api_response
      expect(claim).to receive(:create_event).with 'received_by_jadu'

      Jadu::Claim.create claim
    end

    context 'when the attachment filenames have non alphanumeric characters' do
      let(:claim) { create :claim, :non_sanitized_attachment_filenames }

      let(:attachments) do
        { "et1_barrington_wrigglesworth.pdf" => claim.pdf_file.read,
          "file_l_o_l_biz__v1_.rtf" => claim.claim_details_rtf_file.read,
          "file_l_o_l_biz__v1_.csv" => claim.additional_claimants_csv_file.read }
      end

      it 'converts the hyphens to underscores' do
        expect(api_double).to receive(:new_claim).
          with(xml_double, attachments).and_return successful_api_response

        Jadu::Claim.create claim
      end
    end

    describe 'on failure' do
      before do
        allow(api_double).to receive(:new_claim).
          with(xml_double, attachments).and_return failure_api_response
      end

      it 'raises an execption' do
        expect { Jadu::Claim.create claim }.to raise_error StandardError
      end

      it 'creates a log event' do
        expect(claim).to receive(:create_event).with 'rejected_by_jadu', message: "1 herp derp"
        allow(StandardError).to receive(:new)
        Jadu::Claim.create claim
      end

      it 'does not update the claim' do
        expect(claim).not_to receive(:update)

        allow(StandardError).to receive(:new)
        Jadu::Claim.create claim
      end

      it 'does not finalize the claim' do
        expect(claim).not_to receive(:finalize!)

        allow(StandardError).to receive(:new)
        Jadu::Claim.create claim
      end
    end

    describe 'on success' do
      before do
        allow(api_double).to receive(:new_claim).
          with(xml_double, attachments).and_return successful_api_response
      end

      it 'finalizes the claim' do
        expect(claim).to receive(:finalize!)
        Jadu::Claim.create claim
      end

      describe 'when the API returns a fee group reference' do
        before do
          allow(successful_api_response).to receive(:[]).
            with('feeGroupReference').and_return 123456789000
        end

        it 'updates the claim fee group reference' do
          expect(claim).to receive(:update).with fee_group_reference: 123456789000

          Jadu::Claim.create claim
        end
      end

      describe 'when the API does not return a fee group reference' do
        it 'updates the claim fee group reference' do
          expect(claim).not_to receive(:update).with fee_group_reference: 123456789000

          Jadu::Claim.create claim
        end
      end
    end
  end
end
