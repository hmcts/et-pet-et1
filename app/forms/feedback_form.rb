class FeedbackForm
  include Form::Core

  attribute :comments,      String
  attribute :suggestions,   String
  attribute :email_address, String

  def save
    run_callbacks :save do
      FeedbackSubmissionJob.perform_later attributes
    end
  end
end
