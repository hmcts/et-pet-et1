require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#read_only?' do
    context 'when persisted is false' do
      let(:event) { described_class.new }

      it 'is false' do
        expect(event).not_to be_read_only
      end
    end

    context 'when persisted is true' do
      let(:event) { create(:claim).create_event Event::CREATED }

      it 'is true' do
        expect(event).to be_read_only
      end
    end
  end
end
