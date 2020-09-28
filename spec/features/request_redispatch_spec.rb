require 'rails_helper'

feature 'Request redispatch' do
  include FormMethods

  context 'when the user is not signed' do
    describe 'accessing the claim form' do
      it 'redirects to the start page' do
        visit claim_claimant_path
        expect(page.current_path).to eq apply_path
      end
    end

    describe 'accessing the review page' do
      it 'redirects to the start page' do
        visit claim_review_path
        expect(page.current_path).to eq apply_path
      end
    end

    describe 'accessing the confirmation page' do
      it 'redirects to the start page' do
        visit claim_confirmation_path
        expect(page.current_path).to eq apply_path
      end
    end
  end

  context 'when the user is signed in' do
    let(:claim) { Claim.create user: User.new(password: 'lollolol') }

    before do
      fill_in_return_form claim.reference, 'lollolol'
    end

    describe 'sending users to the correct pages per the claim state' do
      describe 'accessing the claim form when the claim state is' do
        context 'created' do
          before { claim.update state: 'created' }

          specify 'the request is not redirected' do
            visit claim_claimant_path
            expect(page.current_path).to eq claim_claimant_path
          end
        end

        context 'enqueued_for_submission' do
          before { claim.update state: 'enqueued_for_submission' }

          it 'redirects to the confirmation page' do
            visit claim_claimant_path
            expect(page.current_path).to eq claim_confirmation_path(locale: :en)
          end
        end

        context 'submitted' do
          before { claim.update state: 'submitted' }

          it 'redirects to the confirmation page' do
            visit claim_claimant_path
            expect(page.current_path).to eq claim_confirmation_path(locale: :en)
          end
        end
      end

      describe 'accessing the review page when the claim state is' do
        context 'created' do
          before { claim.update state: 'created' }

          specify 'the request is not redirected' do
            visit claim_review_path
            expect(page.current_path).to eq claim_review_path
          end
        end

        context 'enqueued_for_submission' do
          before { claim.update state: 'enqueued_for_submission' }

          it 'redirects to the confirmation page' do
            visit claim_review_path
            expect(page.current_path).to eq claim_confirmation_path(locale: :en)
          end
        end

        context 'submitted' do
          before { claim.update state: 'submitted' }

          it 'redirects to the confirmation page' do
            visit claim_review_path
            expect(page.current_path).to eq claim_confirmation_path(locale: :en)
          end
        end
      end

      describe 'accessing the confirmation page when the claim state is' do
        context 'submitted' do
          before { claim.update state: 'submitted' }

          specify 'the request is not redirected' do
            visit claim_confirmation_path
            expect(page.current_path).to eq claim_confirmation_path
          end
        end

        context 'enqueued_for_submission' do
          before { claim.update state: 'enqueued_for_submission' }

          specify 'the request is not redirected' do
            visit claim_confirmation_path
            expect(page.current_path).to eq claim_confirmation_path
          end
        end

        context 'created' do
          before { claim.update state: 'created' }

          it 'redirects to the claimant page' do
            visit claim_confirmation_path
            expect(page.current_path).to eq claim_claimant_path(locale: :en)
          end
        end
      end
    end
  end
end
