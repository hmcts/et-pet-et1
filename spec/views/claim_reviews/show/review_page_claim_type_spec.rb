require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "claim_type" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end

    let(:null_object) { NullObject.new }
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

    let(:claim_type_section) { review_page.claim_type_section }

    let(:claim) do
      create :claim,
        is_unfair_dismissal: true, is_protective_award: false,
        discrimination_claims: [:sex_including_equal_pay, :race, :sexual_orientation],
        pay_claims: [:redundancy, :other], other_claim_details: "yo\r\nyo",
        is_whistleblowing: true, send_claim_to_whistleblowing_entity: false
    end

    def type_text(text, line_break: true)
      text + (line_break ? '<br>' : '')
    end

    context 'types' do
      it 'concatenates is_unfair_dismissal, discrimination_claims, and pay_claims' do
        expect(claim_type_section.types.answer.native.inner_html).to eq(
          type_text('Unfair dismissal (including constructive dismissal)') +
            type_text('Redundancy pay') +
            type_text('Other payments') +
            type_text('Sex (including equal pay) discrimination') +
            type_text('Race discrimination') +
            type_text('Sexual orientation discrimination', line_break: false)
        )
      end
    end

    it { expect(claim_type_section.whistleblowing.answer).to have_text("Yes") }
    it { expect(claim_type_section.send_to_whistleblowing_body.answer).to have_text("No") }
  end
end
