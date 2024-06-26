require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "with respondent_collection" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end
    let(:additional_respondents_section) { review_page.additional_respondents_section }

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

    describe '#additional_respondents' do
      context 'with secondary respondents' do
        let(:claim) { create(:claim, :with_secondary_respondents) }

        it 'returns "Yes"' do
          expect(additional_respondents_section).not_to have_additional_respondents
        end

        context 'when presenting the list of respondents' do
          it 'has a valid first secondary respondent' do
            expect(additional_respondents_section.respondents[0]).to be_valid_for_model(claim.secondary_respondents[0])
          end

          it 'has a valid second secondary respondent' do
            expect(additional_respondents_section.respondents[1]).to be_valid_for_model(claim.secondary_respondents[1])
          end
        end
      end

      context 'without secondary respondents' do
        let(:claim) { create(:claim) }

        it 'returns "No"' do
          expect(additional_respondents_section.additional_respondents.answer).to have_text 'No'
        end
      end
    end
  end
end
