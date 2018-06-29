require 'rails_helper'

RSpec.describe DiversitiesController, type: :controller do
  describe 'PUT update' do
    let(:diversity_session) { Session.create }

    context 'empty ethinicity' do
      let(:params) {{ "ethnicity" => "" }}

      describe 'redirects to /diversity/disability with a flash' do
        before do
          allow(controller).to receive(:diversity_session).and_return diversity_session
          put :update, diversities_ethnicity: params, page: 'ethnicity'
        end

        it { expect(response).to have_http_status(302) }
        it { expect(response.location).to end_with '/diversity/disability' }
      end
    end

    context '"prefer not to say" ethinicity' do
      let(:params) {{ "ethnicity" => "Prefer not to say" }}

      describe 'redirects to /diversity/disability with a flash' do
        before do
          allow(controller).to receive(:diversity_session).and_return diversity_session
          put :update, diversities_ethnicity: params, page: 'ethnicity'
        end

        it { expect(response).to have_http_status(302) }
        it { expect(response.location).to end_with '/diversity/disability' }
      end
    end

    context '"white" ethinicity' do
      let(:params) {{ "ethnicity" => "White" }}

      describe 'redirects to /diversity/ethnicity-subgroup with a flash' do
        before do
          allow(controller).to receive(:diversity_session).and_return diversity_session
          put :update, diversities_ethnicity: params, page: 'ethnicity'
        end

        it { expect(response).to have_http_status(302) }
        it { expect(response.location).to end_with '/diversity/ethnicity-subgroup' }
      end
    end
  end
end
