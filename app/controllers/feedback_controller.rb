class FeedbackController < ApplicationController
  def create
    resource.assign_attributes params.require(:feedback)
    resource.save

    redirect_to feedback_path, flash: { info: t('.sent') }
  end

  def resource
    @resource ||= FeedbackForm.new({})
  end

  helper_method :resource
end
