require 'rails_helper'

RSpec.describe TimeoutSessionsController, type: :controller do
  before do
    allow(UserSession).to receive(:new).and_return user_session
    allow(Claim).to receive_message_chain(:includes, :find_by).with(application_reference: claim.reference).and_return claim
  end

  let(:user_session) { instance_double(UserSession, claim: claim) }
  let(:email)        { 'sg@example.com' }
  let(:claim)        { create(:claim, user: build(:user, email: email)) }

  describe 'creating events' do
    describe 'for logout' do

      before do
        controller.session[:claim_reference] = claim.reference
      end

      it 'creates a logout event' do
        expect(claim).to receive(:create_event).with 'logout', actor: 'user'
        delete :destroy
      end

      it 'displays a flash message' do
        delete :destroy
        expect(flash[:info]).to eq 'You have been logged out'
      end

      describe 'for email' do
        let(:claim) { create :claim, email_address: nil }

        before do
          allow(user_session).to receive(:email_address).and_return(email)
          allow(user_session).to receive_messages(reference: claim.reference, email_address: email)
          allow(claim).to receive(:create_event).with 'logout', actor: 'user'
        end

        context 'when sending email' do
          it 'logs an email event' do
            expect(claim).to receive(:create_event).with 'deliver_access_details', message: "Sent to #{email}"
            delete :destroy, params: { user_session: { email_address: email } }
          end
        end

        context 'when not sending email' do
          it 'does not log an email event' do
            expect(claim).not_to receive(:create_event).with 'deliver_access_details', message: "Sent to #{email}"
            delete :destroy
          end
        end
      end
    end
  end

  describe 'GET touch' do
    let(:time) { DateTime.new(2015, 1, 1, 1).utc }

    before { session[:claim_reference] = claim.reference }

    it 'refreshes the user session timeout value & renders nothing' do
      travel_to(time) { get :touch }
      expect(session[:expires_in]).to eq(time + 1.hour)
    end
  end
end
