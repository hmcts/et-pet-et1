require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "with respondent" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end
    let(:respondent_section) { review_page.respondent_section }
    let(:respondent) do
      build :respondent, name: 'Lol Corp', address_building: '1', address_street: 'Lol street',
                         address_locality: 'Lolzville', address_county: 'Lolzfordshire',
                         address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
                         acas_early_conciliation_certificate_number: '123',
                         no_acas_number_reason: :acas_has_no_jurisdiction,
                         primary_respondent: true
    end
    let(:claim) { build_stubbed :claim, primary_respondent: respondent }

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

    it { expect(respondent_section.name.answer).to have_text('Lol Corp') }

    describe '#address' do
      it 'concatenates all address properties with a <br> tag' do
        expect(respondent_section.address.answer.native.inner_html).
          to eq('1<br>Lol street<br>Lolzville<br>Lolzfordshire<br>LOL B1Z<br>')
      end
    end

    it { expect(respondent_section.phone.answer).to have_text('01234567890') }

    describe '#acas_early_conciliation_certificate_number' do
      it { expect(respondent_section.acas_number.answer).to have_text '123' }

      context 'when target.acas_number_reason is nil' do
        let(:respondent) do
          build :respondent, name: 'Lol Corp', address_building: '1', address_street: 'Lol street',
                             address_locality: 'Lolzville', address_county: 'Lolzfordshire',
                             address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
                             acas_early_conciliation_certificate_number: '',
                             no_acas_number_reason: :acas_has_no_jurisdiction,
                             primary_respondent: true
        end

        it { expect(respondent_section.acas_number.answer).to have_text("Acas doesn’t have the power to conciliate on some or all of my claim") }
      end
    end

    context 'when worked at a different address' do
      let(:respondent) do
        build :respondent, :without_work_address, name: 'Lol Corp', address_building: '1', address_street: 'Lol street',
                                                  address_locality: 'Lolzville', address_county: 'Lolzfordshire',
                                                  address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
                                                  acas_early_conciliation_certificate_number: '123',
                                                  no_acas_number_reason: :acas_has_no_jurisdiction,
                                                  primary_respondent: true, worked_at_same_address: false
      end

      it 'includes work_address' do
        expect(respondent_section.work_address.answer.native.inner_html).to eq('Not entered')
      end
    end

    context 'when worked at same address' do
      let(:respondent) do
        build :respondent, name: 'Lol Corp', address_building: '1', address_street: 'Lol street',
                           address_locality: 'Lolzville', address_county: 'Lolzfordshire',
                           address_post_code: 'LOL B1Z', address_telephone_number: '01234567890',
                           acas_early_conciliation_certificate_number: '123',
                           no_acas_number_reason: :acas_has_no_jurisdiction,
                           primary_respondent: true, worked_at_same_address: true
      end

      it 'does not include work_address' do
        expect(respondent_section).not_to have_work_address
      end
    end
  end
end
