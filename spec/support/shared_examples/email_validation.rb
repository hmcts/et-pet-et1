RSpec.shared_examples 'Email validation' do |options|
  describe 'validating a email' do
    let(:errors)        { subject.errors[:"email_address"] }
    let(:error_message) { options[:error_message] }

    context 'when no email' do
      before do
        subject.send :"email_address=", ''
        subject.valid?
      end

      it 'does not add any errors' do
        expect(errors).not_to include error_message
      end
    end

    context 'when it is not a valid email' do
      before do
        subject.send :"email_address=", 'lol@ biz.info'
        subject.valid?
      end

      it 'adds an error to the email attribute' do
        expect(errors).to include error_message
      end
    end

    context 'when it is a valid email' do
      before do
        subject.send :"email_address=", 'lol@biz.info'
        subject.valid?
      end

      it 'does not add any errors' do
        expect(errors).to be_empty
      end
    end
  end
end
