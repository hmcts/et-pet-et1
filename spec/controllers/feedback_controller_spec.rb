require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  describe 'POST create' do
    let(:form) { instance_double(FeedbackForm, save: true, assign_attributes: {}) }

    let(:params) do
      { comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com' }
    end

    before { allow(FeedbackForm).to receive(:new).and_return form }

    it 'assings orderd attributes' do
      expect(form).to receive(:assign_attributes).with(params).ordered

      post :create, feedback: params
    end

    it 'saves the form' do
      expect(form).to receive(:save).ordered

      post :create, feedback: params
    end

    it 'response is redirect' do
      post :create, feedback: params

      expect(response).to have_http_status(302)
    end

    it 'redirect location is feedback page' do
      post :create, feedback: params

      expect(response.location).to end_with '/apply/feedback'
    end

    it 'sets a flash message ' do
      post :create, feedback: params

      expect(flash[:info]).to eq 'Thank you for your feedback'
    end
  end
end
