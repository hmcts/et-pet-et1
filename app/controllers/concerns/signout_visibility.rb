module SignoutVisibility
  extend ActiveSupport::Concern

  def show_signout?
    !@hide_signout
  end

  def hide_signout
    @hide_signout = true
  end

  included do
    helper_method :show_signout?
  end
end
