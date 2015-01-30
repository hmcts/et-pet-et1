require 'rails_helper'

RSpec.describe PdfsController, type: :controller do
  describe 'show' do

    before :each do
      session[:claim_reference] = claim.reference
      get :show
    end

    context 'pdf is available' do
      let(:claim) { create :claim, :with_pdf }

      it 'redirects to an amazon s3 url with a 10 minute expiry' do
        url_path_part = url_path_part_for claim
        expect(response).to redirect_to(/^#{Regexp.quote url_path_part}/)
      end
    end

    context 'pdf is unavailable' do
      let(:claim) { create :claim }

      it 'sends the user to the pdf holding page' do
        expect(response).to render_template "show"
      end
    end
  end

  def url_path_part_for(claim)
    ["https://",
      "#{ENV.fetch('S3_UPLOAD_BUCKET')}.s3-eu-west-1.amazonaws.com/",
      "uploads/claim/pdf/",
      "#{claim.reference}/",
      "et1_barrington_wrigglesworth.pdf",
      "?X-Amz-Expires=600"].join
  end
end
