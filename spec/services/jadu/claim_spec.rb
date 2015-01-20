require 'rails_helper'

RSpec.describe Jadu::Claim, type: :service do
  let(:api_double) { instance_double Jadu::API }
  let(:endpoint)   { "https://etapi.employmenttribunals.service.gov.uk/1/" }
  let(:xml)        { instance_double JaduXml::ClaimPresenter, to_xml: xml_double }
  let(:xml_double) { double :xml }
  let(:claim)      { create :claim }

  let(:successful_api_response) do
    double(:successful_api_response, ok?: true).tap do |d|
      allow(d).to receive(:[])
    end
  end

  let(:failure_api_response) do
    double(:failure_api_response, ok?: false).tap do |d|
      allow(d).to receive(:[])
    end
  end

  let(:attachments) do
    { "et1_barrington_wrigglesworth.pdf" => claim.pdf_file.read,
      "file.rtf" => claim.additional_information_rtf_file.read,
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

    context 'when the attachment filenames have underscores' do
      let(:claim) { create :claim, :non_sanitized_attachment_filenames }

      let(:attachments) do
        { "et1_barrington_wrigglesworth.pdf" => claim.pdf_file.read,
          "file_lol_biz_v1.rtf" => claim.additional_information_rtf_file.read,
          "file_lol_biz_v1.csv" => claim.additional_claimants_csv_file.read }
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

      it 'does not update the claim' do
        expect(claim).not_to receive(:update)

        begin
          Jadu::Claim.create claim
        rescue StandardError
        end
      end

      it 'does not finalize the claim' do
        expect(claim).not_to receive(:finalize!)

        begin
          Jadu::Claim.create claim
        rescue StandardError
        end
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
