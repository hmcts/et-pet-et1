require 'rails_helper'

RSpec.describe "Additional Claimants page", type: :request do
  include Capybara::DSL
  describe "/apply/additional-claimants" do
    include_examples 'google tag manager', page_object_class: ET1::Test::ClaimAdditionalClaimantsPage do
      let(:claim) { create(:claim, :not_submitted) }
      before do
        set_rails_session_cookie(claim_reference: claim.application_reference, expires_in: 1.hour.from_now)
      end
    end
  end
end
