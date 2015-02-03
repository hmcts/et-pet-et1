module SignoutVisibilityHelper
  def show_signout?
    return unless action_name == 'show'

    case controller_name
    when 'claims'
      params[:page] != 'application-number'
    when *%w<claim_reviews payments multiples>
      true
    else
      false
    end
  end
end
