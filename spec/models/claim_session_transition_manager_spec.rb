require 'rails_helper'

RSpec.describe ClaimSessionTransitionManager do
  describe 'perform!' do
    let(:params)  { Hash.new }
    let(:session) { Hash.new }
    let(:manager) { ClaimSessionTransitionManager.new params: params, session: session }

    describe 'transitioning from no state' do
      it 'sets :current_step to :personal' do
        manager.perform!
        expect(manager.current_step).to eq(:personal)
      end
    end

    describe 'transitioning from :personal' do
      before { session[:step_stack] = %i<personal> }

      it 'sets :current_step to :employer' do
        manager.perform!
        expect(manager.current_step).to eq(:employer)
      end

      it 'sets :previous_step to :personal' do
        manager.perform!
        expect(manager.previous_step).to eq(:personal)
      end

      describe 'when params contain :has_representative' do
        before do
          session[:step_stack] = %i<personal>
          params[:has_representative] = true
        end

        it 'sets :current_step to :representative' do
          manager.perform!
          expect(manager.current_step).to eq(:representative)
        end
      end
    end

    describe 'transitioning from :representative' do
      before { session[:step_stack] = %i<personal representative> }

      it 'sets :current_step to :employer' do
        manager.perform!
        expect(manager.current_step).to eq(:employer)
      end

      it 'sets :previous_step to :representative' do
        manager.perform!
        expect(manager.previous_step).to eq(:representative)
      end
    end

    describe 'transitioning from :employer' do
      before { session[:step_stack] = %i<personal employer> }

      it 'sets :current_step to :claim' do
        manager.perform!
        expect(manager.current_step).to eq(:claim)
      end


      it 'sets :previous_step to :employer' do
        manager.perform!
        expect(manager.previous_step).to eq(:employer)
      end


      describe 'when params contain :was_employed' do
        before do
          session[:step_stack] = %i<personal representative employer>
          params[:was_employed] = true
        end

        it 'sets :current_step to :employment' do
          manager.perform!
          expect(manager.current_step).to eq(:employment)
        end

        it 'sets :previous_step to :employer' do
          manager.perform!
          expect(manager.previous_step).to eq(:employer)
        end
      end
    end

    describe 'transitioning from :employment' do
      before { session[:step_stack] = %i<personal representative employer employment> }

      it 'sets :current_step to :claim' do
        manager.perform!
        expect(manager.current_step).to eq(:claim)
      end

      it 'sets :previous_step to :employment' do
        manager.perform!
        expect(manager.previous_step).to eq(:employment)
      end
    end
  end
end
