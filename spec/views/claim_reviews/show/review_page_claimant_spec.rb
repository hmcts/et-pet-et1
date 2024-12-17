require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "with claim_type" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end
    let(:claimant_section) { review_page.claimant_section }
    let(:claimant) do
      build(:claimant,
            title: 'Mr', first_name: 'Stevie', last_name: 'Graham', gender: 'male',
            date_of_birth: Date.civil(1999, 1, 15), address_building: '1',
            address_street: 'Lol street', address_locality: 'Lolzville',
            address_county: 'Lolzfordshire', address_post_code: 'LOL B1Z',
            address_telephone_number: '01234567890', mobile_number: '07956123456',
            email_address: 'joe@example.com', contact_preference: 'post',
            special_needs: false, primary_claimant: true)
    end
    let(:claim) { create(:claim, primary_claimant: claimant) }

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

    describe '#full_name' do
      it 'concatenates title, first_name and last_name' do
        expect(claimant_section.full_name.answer).to have_text('Mr Stevie Graham')
      end
    end

    it { expect(claimant_section.gender.answer).to have_text('Male') }
    it { expect(claimant_section.date_of_birth.answer).to have_text("15 January 1999") }

    describe '#address' do
      it 'concatenates all address properties with a <br> tag' do
        expect(claimant_section.address.answer.native.inner_html).
          to eql('1<br>Lol street<br>Lolzville<br>Lolzfordshire<br>LOL B1Z<br>')
      end
    end

    it { expect(claimant_section.phone.answer).to have_text('01234567890') }
    it { expect(claimant_section.mobile.answer).to have_text('07956123456') }
    it { expect(claimant_section.email.answer).to have_text('joe@example.com') }
    it { expect(claimant_section.preferred_contact.answer).to have_text('Post') }
    it { expect(claimant_section.allow_phone_or_video_attendance.answer).to have_text('Yes, I can take part in video hearings') }

    describe '#is_disabled' do
      context 'when the claimant is disabled' do
        let(:claimant) do
          build(:claimant,
                title: 'Mr', first_name: 'Stevie', last_name: 'Graham', gender: 'male',
                date_of_birth: Date.civil(1999, 1, 15), address_building: '1',
                address_street: 'Lol street', address_locality: 'Lolzville',
                address_county: 'Lolzfordshire', address_post_code: 'LOL B1Z',
                address_telephone_number: '01234567890', mobile_number: '07956123456',
                email_address: 'joe@example.com', contact_preference: 'post',
                has_special_needs: true, primary_claimant: true)
        end

        specify { expect(claimant_section.assistance_required.answer).to have_text('Yes') }
      end
    end
  end
end
