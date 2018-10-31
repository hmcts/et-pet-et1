require 'rails_helper'

RSpec.describe "Pdf page", type: :request do
  include Capybara::DSL
  describe "/apply/pdf" do
    include_examples 'google tag manager', page_object_class: ET1::Test::PdfPage do
      let(:claim) { create(:claim) }
      before do
        set_rails_session_cookie(claim_reference: claim.application_reference, expires_in: 1.hour.from_now)
      end
    end
  end
end
