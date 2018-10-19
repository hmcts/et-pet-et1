require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "representative" do
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

    let(:representative_section) { review_page.representative_section }
    let(:representative) do
      Representative.new type: :law_centre,
        organisation_name: 'Better Call Saul', name: 'Saul Goodman',
        address_building: '1', address_street: 'Lol street',
        address_locality: 'Lolzville', address_county: 'Lolzfordshire',
        address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
        mobile_number: '07956123456', contact_preference: 'post', dx_number: '1'
    end
    let(:claim) { create :claim, representative: representative }

    it { expect(representative_section.type_of_representative.answer).to have_text('Law centre') }
    it { expect(representative_section.organisation_name.answer).to have_text('Better Call Saul') }
    it { expect(representative_section.full_name.answer).to have_text('Saul Goodman') }
    it { expect(representative_section.phone.answer).to have_text('01234567890') }
    it { expect(representative_section.mobile.answer).to have_text('07956123456') }
    it { expect(representative_section.dx_number.answer).to have_text('1') }
    it { expect(representative_section.preferred_contact.answer).to have_text('Post') }
    it { expect(representative_section.email.answer).to have_text('Not entered') }

    describe '#address' do
      it 'concatenates all address properties with a <br> tag' do
        expect(representative_section.address.answer.native.inner_html).
          to eq('1<br>Lol street<br>Lolzville<br>Lolzfordshire<br>LOL B1Z<br>')
      end
    end

    context 'when target.representative is blank' do
      let(:claim) { create(:claim, representative: nil) }

      it 'yields has_representative no' do
        expect(representative_section.representative.answer).to have_text('No')
      end
    end
  end
end
