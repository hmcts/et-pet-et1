require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  describe 'POST create' do
    let(:form) { instance_double(FeedbackForm, save: true, assign_attributes: {}) }

    let(:params) do
      { comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com' }
    end

    before { allow(FeedbackForm).to receive(:new).and_return form }

    it 'saves the form' do
      expect(form).to receive(:assign_attributes) do |args|
        expect(args.to_unsafe_hash).to eq(params.stringify_keys)
      end
      post :create, feedback: params
    end

    it 'return ordered result' do
      expect(form).to receive(:save).ordered
      post :create, feedback: params
    end

    describe 'redirects to /apply/feedback with a flash' do
      before { post :create, feedback: params }

      it { expect(response).to have_http_status(302) }
      it { expect(response.location).to end_with '/apply/feedback' }
      it { expect(flash[:info]).to eq 'Thank you for your feedback' }
    end
  end
end
