require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "with claim_outcome" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end
    let(:claim) do
      create(:claim, desired_outcomes: [:tribunal_recommendation, :new_employment_and_compensation],
                     other_outcome: "25 bags\r\nyour job")
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

    context 'with outcome details' do
      subject(:page) { review_page.claim_outcome_section.what_outcome.answer.native.inner_html }

      it do
        expect(page).
          to eq "A recommendation from a tribunal (that the employer takes action so that the problem at work doesn’t happen again)" \
                "<br>To get another job with the same employer or associated employer"
      end
    end

    context 'with outcome' do
      subject { review_page.claim_outcome_section.outcome_details.answer.native.inner_html }

      it { is_expected.to eq("25 bags\n<br>your job") }
    end
  end
end
