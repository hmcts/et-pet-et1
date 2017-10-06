class RefundsController < ApplicationController
  def new
    refund_session = Session.create
    session[:refund_session_id] = refund_session.id
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
    @form ||= Form.for("refunds/#{current_step}").new(refund_session)
  end

  def current_step
    params[:page].underscore
  end

  def refund
    @refund ||= load_refund_from_session
  end

  def refund_session
    @refund_session ||= load_refund_session_from_session
  end

  def load_refund_session_from_session
    refund_session = if session[:refund_session_id].present?
                       Session.find_by(id: session[:refund_session_id])
                     end
    refund_session ||= Session.create.tap { |s| session[:refund_session_id] = s.id.to_s }
    refund_session
  end

  def load_refund_from_session
    return nil if session[:refund_id].blank?
    Refund.find_by(id: session[:refund_id])
  end

  helper_method :refund_path_for, :refund, :current_step, :page_manager, :resource
end
