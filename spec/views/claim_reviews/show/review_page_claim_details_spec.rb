require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "with claim_details" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end
    let(:claim) do
      create(:claim, claim_details: "wut\r\nwut", other_known_claimants: true, other_known_claimant_names: "Johnny Wishbone\r\nSamuel Pepys")
    end

    let(:null_object) { NullObject.new }

    before do
      view.singleton_class.class_eval do
        def claim_path_for(*)
          '/anything'
        end
      end
      render template: "claim_reviews/show", locals: {
        claim:,
        primary_claimant: claim.primary_claimant || null_object,
        representative: claim.representative || null_object,
        employment: claim.employment || null_object,
        respondent: claim.primary_respondent || null_object,
        secondary_claimants: claim.secondary_claimants,
        secondary_respondents: claim.secondary_respondents
      }
      review_page.load(rendered.to_s)
    end

    context 'with claim details' do
      subject { review_page.claim_details.claim_details.answer.native.inner_html }

      it { is_expected.to eq("wut\n<br>wut") }
    end

    context 'with other known claimant names' do
      subject { review_page.claim_details.other_known_claimants.answer.native.inner_html }

      it { is_expected.to eq("Johnny Wishbone\n<br>Samuel Pepys") }
    end

    context 'when documents attached' do
      subject { review_page.claim_details.attached_documents.answer.native.inner_html }

      it { is_expected.to eq('file.rtf') }
    end
  end
end
