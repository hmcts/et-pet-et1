module PageHelper
  def start_session_timer?
    unless_new_path = -> { action_name != 'new' }
    is_claim_page? claims_condition: unless_new_path
  end

  def show_signout?
    unless_new_path_or_application_form = \
      -> { action_name != 'new' && params[:page] != 'application-number' }

    is_claim_page? claims_condition: unless_new_path_or_application_form
  end

  def is_claim_page?(claims_condition: -> { true })
    case controller_name
    when 'claims' then claims_condition.call
    when *claim_pages_list then true
    else false
    end
  end

  private

  def claim_pages_list
    ['claim_reviews', 'payments', 'multiples']
  end
end
