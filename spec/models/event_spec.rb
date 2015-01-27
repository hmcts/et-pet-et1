require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#read_only?' do
    context 'when persisted is false' do
      subject { described_class.new }

      it 'is false' do
        expect(subject).not_to be_read_only
      end
    end

    context 'when persisted is true' do
      subject { create(:claim).create_event Event::CREATED }

      it 'is true' do
        expect(subject).to be_read_only
      end
    end
  end
end
