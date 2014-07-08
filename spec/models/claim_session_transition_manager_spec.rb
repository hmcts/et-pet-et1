require "rails_helper"

RSpec.describe ClaimSessionTransitionManager do
  describe "#perform!" do
    let(:params)   { Hash.new }
    let(:session)  { Hash.new }
    let(:manager)  { ClaimSessionTransitionManager.new session: session }
    let(:resource) { double('resource') }

    describe "initial state" do
      subject { manager.current_step }
      it { is_expected.to eq('password') }
    end

    describe "transitioning from initial state" do
      it "sets current_step to 'claimant'" do
        manager.perform! resource: resource
        expect(manager.current_step).to eq('claimant')
      end
    end

    describe "transitioning from 'claimant'" do
      before do
        session['step_stack'] = %w<password claimant>
        allow(resource).to receive(:has_representative) { false }
      end

      it "sets current_step to 'respondent'" do
        manager.perform! resource: resource
        expect(manager.current_step).to eq('respondent')
      end

      it "sets previous_step to 'claimant'" do
        manager.perform! resource: resource
        expect(manager.previous_step).to eq('claimant')
      end

      describe "when params contain 'has_representative'" do
        before do
          session['step_stack'] = %w<password claimant>
          allow(resource).to receive(:has_representative) { true }
        end

        it "sets current_step to 'representative'" do
          manager.perform! resource: resource
          expect(manager.current_step).to eq('representative')
        end
      end
    end

    describe "transitioning from 'representative'" do
      before { session['step_stack'] = %w<password claimant representative> }

      it "sets current_step to 'respondent'" do
        manager.perform! resource: resource
        expect(manager.current_step).to eq('respondent')
      end

      it "sets previous_step to 'representative'" do
        manager.perform! resource: resource
        expect(manager.previous_step).to eq('representative')
      end
    end

    describe "transitioning from 'respondent'" do
      before do
        session['step_stack'] = %w<password claimant respondent>
        allow(resource).to receive(:was_employed) { false }
      end

      it "sets current_step to 'claim'" do
        manager.perform! resource: resource
        expect(manager.current_step).to eq('claim')
      end


      it "sets previous_step to 'respondent'" do
        manager.perform! resource: resource
        expect(manager.previous_step).to eq('respondent')
      end


      describe "when params contain 'was_employed'" do
        before do
          session['step_stack'] = %w<password claimant representative respondent>
          allow(resource).to receive(:was_employed) { true }
        end

        it "sets current_step to 'employment'" do
          manager.perform! resource: resource
          expect(manager.current_step).to eq('employment')
        end

        it "sets previous_step to 'respondent'" do
          manager.perform! resource: resource
          expect(manager.previous_step).to eq('respondent')
        end
      end
    end

    describe "transitioning from 'employment'" do
      before { session['step_stack'] = %w<password claimant representative respondent employment> }

      it "sets current_step to 'claim'" do
        manager.perform! resource: resource
        expect(manager.current_step).to eq('claim')
      end

      it "sets previous_step to 'employment'" do
        manager.perform! resource: resource
        expect(manager.previous_step).to eq('employment')
      end
    end

    describe "transitioning from 'claim'" do
      before { session['step_stack'] = %w<password claimant representative respondent employment claim> }

      it "sets current_step to 'confirmation'" do
        manager.perform! resource: resource
        expect(manager.current_step).to eq('confirmation')
      end

      it "sets previous_step to 'claim'" do
        manager.perform! resource: resource
        expect(manager.previous_step).to eq('claim')
      end
    end
  end
end
