require 'rails_helper'

RSpec.describe Session, type: :model do
  subject(:session) { described_class.new }

  context 'with virtual attributes' do
    it 'adds to the data hash when a writer is called' do
      session.virtual_attribute_1 = 'test'
      expect(session.data).to include('virtual_attribute_1' => 'test')
    end

    it 'persists virtual attributes' do
      session.virtual_attribute_1 = 'test'
      session.save

      fetched_session = described_class.find(session.id)
      expect(fetched_session.virtual_attribute_1).to eql 'test'
    end

    it 'responds to the writer method' do
      expect(session).to respond_to(:virtual_attribute_1=)
    end

    it 'responds to the reader method' do
      session.virtual_attribute_1 = 'test'
      expect(session).to respond_to(:virtual_attribute_1)
    end

    it 'responds to the reader method if it hasnt been set' do
      expect(session).to respond_to(:virtual_attribute_1)
    end
  end

  describe '#to_h' do
    it 'outputs the data as a hash' do
      session.virtual_attribute_1 = 'test 1'
      session.virtual_attribute_2 = 'test 2'
      expect(session.to_h).to eql('virtual_attribute_1' => 'test 1', 'virtual_attribute_2' => 'test 2')
    end

    it 'isolates the returned value from the internal data' do
      session.virtual_attribute_1 = 'test 1'
      expect(session.to_h).not_to be session.data
    end
  end
end
