require 'rails_helper'

RSpec.describe FeedbackSubmissionJob, type: :job do
  describe '#perform' do
    let(:feedback_submission_job) { FeedbackSubmissionJob.new }
    let(:emails_sent) { ::Et1::Test::EmailsSent.new }

    it 'sends an HTML email to service now' do
      feedback_submission_job.perform comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com'

      expect(emails_sent.feedback_html_email_for email_address: 'hue@example.com').to be_present
    end

    it 'sends a text email to service now' do
      feedback_submission_job.perform comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com'

      expect(emails_sent.feedback_text_email_for email_address: 'hue@example.com').to be_present
    end

    it 'sends an text email to service now with the correct content' do
      feedback_submission_job.perform comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com'

      expect(emails_sent.feedback_text_email_for email_address: 'hue@example.com').to have_correct_content_for(comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com')
    end

    it 'sends an html email to service now with the correct content' do
      feedback_submission_job.perform comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com'

      expect(emails_sent.feedback_html_email_for email_address: 'hue@example.com').to have_correct_content_for(comments: 'lél', suggestions: 'lewl', email_address: 'hue@example.com')
    end

    context 'without an email address' do
      let(:placeholder_email_address) { "anonymous@example.com" }

      it 'sends an HTML email to service now using a placeholder email' do
        feedback_submission_job.perform comments: 'lél', suggestions: 'lewl'

        expect(emails_sent.feedback_html_email_for email_address: placeholder_email_address).to be_present
      end
      it 'sends an HTML email to service now using a placeholder email' do
        feedback_submission_job.perform comments: 'lél', suggestions: 'lewl'

        expect(emails_sent.feedback_html_email_for email_address: placeholder_email_address).to be_present
      end
    end
  end
end
