class FeedbackMailer < ApplicationMailer
  def service_now_email(service_now_email: Rails.application.config.service_now_inbox_email)
    @comments = params[:comments]
    @suggestions = params[:suggestions]
    @requester = params[:requester]
    mail(to: service_now_email, subject: 'New ATET User Feedback')
  end
end
