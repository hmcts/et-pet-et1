class FeedbackController < ApplicationController
  before_action :hide_signout

  def create
    resource.assign_attributes params[:feedback]
    resource.save

    redirect_to feedback_path, notice: t('.sent')
  end

  def resource
    @resource ||= FeedbackForm.new
  end

  helper_method :resource
end
