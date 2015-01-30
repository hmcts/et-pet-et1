class FeedbackForm
  include Form::Core

  attribute :comments,      String
  attribute :suggestions,   String
  attribute :email_address, String

  def save
    if valid?
      run_callbacks :save do
        FeedbackSubmissionJob.perform_later attributes
      end
    else
      false
    end
  end
end
