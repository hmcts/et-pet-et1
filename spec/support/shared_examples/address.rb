RSpec.shared_examples 'it has an address' do |prefix|
  describe 'delegation' do
    [:building, :street, :locality, :county, :post_code, :telephone_number].each do |attr|
      describe "#{prefix}_#{attr}" do
        it "is delegated to ##{prefix} as #{attr}" do
          expect(subject.send(prefix)).to receive(attr)
          subject.send :"#{prefix}_#{attr}"
        end
      end

      describe "#{prefix}_#{attr}=" do
        let(:object) { double }

        it "is delegated to ##{prefix} as #{attr}=" do
          expect(subject.send(prefix)).to receive(:"#{attr}=").with object
          subject.send :"#{prefix}_#{attr}=", object
        end
      end
    end
  end
end
