require 'rails_helper'

RSpec.describe DiversitiesController, type: :controller do
  describe 'PUT update' do
    let(:diversity_session) { Session.create }

    context 'when on the confirmation page' do
      before do
        allow(controller).to receive(:diversity_session).and_return diversity_session
      end

      it "render the page as usual" do
        get :show, params: { page: 'confirmation' }
        expect(response).to have_http_status(:ok)
      end

      it 'destroy the session' do
        expect(diversity_session).to receive(:destroy)
        get :show, params: { page: 'confirmation' }
      end
    end

    context 'when expired session' do
      before do
        session[:expires_in] = 2.minutes.ago
        allow(controller).to receive(:diversity_session).and_return diversity_session
      end

      it "redirect the page" do
        get :show, params: { page: 'confirmation' }
        expect(response).to redirect_to(new_diversity_url)
      end
    end
  end
end
