module SignoutVisibilityHelper
  def show_signout?
    case controller_name
    when 'claims'                              then applicable_claim_page?
    when *%w<claim_reviews payments multiples> then true
    else false
    end
  end

  private def applicable_claim_page?
    action_name != 'new' && params[:page] != 'application-number'
  end
end
