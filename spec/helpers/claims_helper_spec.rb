require 'rails_helper'

RSpec.describe ClaimsHelper, type: :helper do
  let(:english_link) { 'https://www.gov.uk/done/employment-tribunals-make-a-claim' }
  let(:default_link) { "/apply/feedback?locale=#{I18n.locale}" }

  describe 'feedback link' do
    context 'when English' do
      before { I18n.locale = :en }
      it { expect(helper.language_specific_feedback_url).to eql(english_link) }
    end

    context 'when Welsh' do
      before { I18n.locale = :cy }
      it { expect(helper.language_specific_feedback_url).to eql(default_link) }
    end
  end
end
