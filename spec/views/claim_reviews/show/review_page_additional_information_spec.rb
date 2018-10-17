require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "additional_information" do

    before do
      controller.singleton_class.class_eval %Q{
        include Rails.application.routes.url_helpers
        protected
        def claim
          Claim.find(#{claim.id})
        end
        def claim_path_for(page, options = {})
          send "claim_\#{page}_path".underscore, options
        end

        helper_method :claim, :claim_path_for
      }
    end
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end

    context 'temp' do
      let(:claim) { create :claim, miscellaneous_information: "hey\r\nhey" }

      before do
        render template: "claim_reviews/show", locals: {
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
end
