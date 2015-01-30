require 'rails_helper'

RSpec.describe FeedbackController, :type => :controller do
  describe 'POST create' do
    let(:form) { instance_double(FeedbackForm, save: true, assign_attributes: {}) }

    let(:params) do
      { comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com' }
    end

    before { allow(FeedbackForm).to receive(:new).and_return form }

    it 'saves the form' do
      expect(form).to receive(:assign_attributes).with(params).ordered
      expect(form).to receive(:save).ordered

      post :create, feedback: params
    end

    it 'redirects to /apply/feedback with a flash' do
      post :create, feedback: params

      expect(response).to be_redirect
      expect(response.location).to end_with '/apply/feedback'
      expect(flash[:notice]).to eq 'Thank you for your feedback'
    end
  end
end
