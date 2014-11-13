RSpec.shared_examples 'it parses dates', focus: true do |*dates|
  dates.each do |date|
    subject { described_class.new Claim.new }

    it 'assigns the concrete date value when all parts are present and valid' do
      subject.send "#{date}=", 'day' => '15', 'month' => '1', 'year' => '1985'

      expect(subject.send date).to eq Date.civil(1985, 1, 15)
    end

    describe 'validation' do
      context "when no #{date} has been given" do
        before { subject.valid? }

        specify "there are no date errors on #{date}" do
          expect(subject.errors[date]).to be_empty
        end
      end

      context "when a 'blank' #{date} has been given" do
        before do
          subject.send "#{date}=", 'day' => '', 'month' => '', '' => ''
          subject.valid?
        end

        specify "there are no date errors on #{date}" do
          expect(subject.errors[date]).to be_empty
        end

        it "it does not update the value of #{date}" do
          expect(subject.send date).to be nil
        end
      end

      describe 'handling invalid dates' do
        let(:model_translation_path) do
          "activemodel.errors.models.#{described_class.model_name.name}.attributes.#{date}.invalid"
        end

        context "when a non-numeric #{date} has been given" do
          before do
            subject.send "#{date}=", 'day' => 'wat', 'month' => 'da', 'year' => 'fuq'
            subject.valid?
          end

          it "adds a validation error to #{date}" do
            expect(subject.errors[date]).to include I18n.t(model_translation_path)
          end
        end

        context 'when a numeric date with out of bounds segments has been given' do
          before do
            subject.send "#{date}=", 'day' => '64', 'month' => '32', 'year' => '2014'
            subject.valid?
          end

          it "adds a validation error to #{date}" do
            expect(subject.errors[date]).to include I18n.t(model_translation_path)
          end
        end
      end
    end
  end
end
