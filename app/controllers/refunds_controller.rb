class RefundsController < ApplicationController
  def new
    refund = Refund.create
    session[:refund_id] = refund.id
    redirect_to refund_path_for RefundPagesManager.first_page
  end

  def update
    resource.assign_attributes params.fetch("refunds_#{current_step}", {})

    if resource.save
      redirect_to next_page
    else
      render action: :show
    end
  end

  private

  def next_page
    if params[:return_to_review].present?
      refund_review_path
    else
      refund_path_for page_manager.forward
    end
  end

  def refund_path_for(page, options = {})
    send "refund_#{page}_path".underscore, options
  end

  def page_manager
    @page_manager ||= RefundPagesManager.new(resource: resource)
  end

  def resource
    @form ||= Form.for("refunds/#{current_step}").new(refund)
  end

  def current_step
    "#{params[:page]}".underscore
  end


  helper_method :refund_path_for, :current_step, :page_manager, :resource

end
