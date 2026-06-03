require 'rails_helper'

RSpec.describe 'ErrorTests' do
  let(:token) { 'test-token' }

  before do
    allow(Rails.application.config).to receive(:error_test_page_token).and_return(token)
  end

  describe 'GET /error_test' do
    it 'returns not found when no token is supplied' do
      get error_test_path

      expect(response).to have_http_status(:not_found)
    end

    it 'renders the hidden page when the token matches' do
      get error_test_path(token: token)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Trigger JavaScript error')
      expect(response.body).to include('Trigger Ruby error')
    end
  end

  describe 'POST /error_test' do
    it 'returns not found when the token is wrong' do
      post error_test_path(token: 'wrong-token')

      expect(response).to have_http_status(:not_found)
    end

    it 'raises the deliberate Ruby error when the token matches' do
      expect do
        post error_test_path(token: token)
      end.to raise_error(RuntimeError, 'Deliberate Ruby error triggered from the hidden error test page')
    end
  end
end
