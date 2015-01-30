require 'rails_helper'

RSpec.describe FeedbackForm, type: :form do
  describe '#save' do
    subject do
      described_class.new \
        comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com'
    end

    it 'enqueues a feedback submission job' do
      expect(FeedbackSubmissionJob).
        to receive(:perform_later).
        with comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com'

      subject.save
    end
  end
end
