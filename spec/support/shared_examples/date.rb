RSpec.shared_examples 'it parses and validates multiparameter dates', focus: true do |*dates|
  dates.each do |date|
    subject { described_class.new }

    it 'exposes methods for each part' do
      has_interface = 1.upto(3).
        flat_map { |index| [:"#{date}(#{index}i)", :"#{date}(#{index}i)="] }.
        all?     { |meth| subject.respond_to? meth }

      expect(has_interface).to be true
    end

    it 'assigns the concrete date value when all parts are present and valid' do
      subject.send "#{date}(1i)=", '1985'
      subject.send "#{date}(2i)=", '1'
      subject.send "#{date}(3i)=", '15'

      expect(subject.send date).to eq Date.civil(1985, 1, 15)
    end

    describe 'validation' do
      context "when no #{date} has been given" do
        before { subject.valid? }

        specify "there are no date errors on #{date}" do
          expect(subject.errors[date]).to be_empty
        end
      end

      context "when an invalid #{date} has been given" do
        before do
          subject.send "#{date}(1i)=", '1985'
          subject.send "#{date}(2i)=", ''
          subject.send "#{date}(3i)=", ''
        end

        it "adds a validation error to #{date}" do
          subject.valid?
          expect(subject.errors[date]).to include('is invalid')
        end
      end
    end
  end
end
