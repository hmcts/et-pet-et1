require 'rails_helper'

RSpec.describe DiversitiesController, type: :controller do
  describe 'PUT update' do
    let(:diversity_session) { Session.create }

    context 'confirmation page' do
      let(:params) { { "ethnicity" => "" } }

      before do
        allow(controller).to receive(:diversity_session).and_return diversity_session
      end

      it "render the page as usual" do
        get :show,  page: 'confirmation'
        expect(response).to have_http_status(200)
      end

      it 'destroy the session' do
        expect(diversity_session).to receive(:destroy)
        get :show,  page: 'confirmation'
        expect(response).to have_http_status(200)
      end
    end

  end
end
