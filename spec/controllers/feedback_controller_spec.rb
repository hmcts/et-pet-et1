require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  describe 'POST create' do
    let(:form) { instance_double(FeedbackForm, save: true, assign_attributes: {}) }

    let(:params) do
      { subtitle: "", comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com' }
    end

    before do
      allow(FeedbackForm).to receive(:new).and_return form
      session[:invisible_captcha_timestamp] = 60.seconds.ago.iso8601
    end

    it 'saves the form' do
      expect(form).to receive(:assign_attributes).with(an_object_having_attributes(to_unsafe_hash: params.except(:subtitle).stringify_keys))
      post :create, params: { feedback: params }
    end

    it 'return ordered result' do
      expect(form).to receive(:save).ordered
      post :create, params: { feedback: params }
    end

    describe 'redirects to /apply/feedback with a flash' do
      before { post :create, params: { feedback: params } }

      it { expect(response).to have_http_status(302) }
      it { expect(response.location).to end_with '/en/apply/feedback' }
      it { expect(flash[:info]).to eq 'Thank you for your feedback' }
    end
  end
end
