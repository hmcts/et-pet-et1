require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "additional_information" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end

    let(:null_object) { NullObject.new }
    let(:claim) { build_stubbed :claim, miscellaneous_information: "hey\r\nhey" }

    before do
      render template: "claim_reviews/show", locals: {
        claim: claim,
        primary_claimant: claim.primary_claimant || null_object,
        representative: claim.representative || null_object,
        employment: claim.employment || null_object,
        respondent: claim.primary_respondent || null_object,
        secondary_claimants: claim.secondary_claimants,
        secondary_respondents: claim.secondary_respondents
      }
      review_page.load(rendered)
    end

    describe '#additional_information' do
      subject { review_page.additional_information.important_details.answer.native.inner_html }

      it { is_expected.to eq("hey\n<br>hey") }

    end
  end
end
