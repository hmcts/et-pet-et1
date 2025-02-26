require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "with case_heard_by" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end
    let(:case_heard_by_section) { review_page.case_heard_by_section }
    let(:claim) { create(:claim) }

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

    it { expect(case_heard_by_section.case_heard_by_preference.answer).to have_text('I prefer my case to be heard by a judge') }
    it { expect(case_heard_by_section.case_heard_by_preference_reason.answer).to have_text('I feel intimidated by a group') }
  end
end
