class ClaimSubmittedPage < BasePage
  element :save_a_copy_link, :link, 'Save a copy'
  def save_a_copy
    self.popup_window = window_opened_by { save_a_copy_link.click }
  end

  def within_popup_window(&block)
    raise "Popup window not opened" if popup_window.nil?
    within_window(popup_window, &block)
  end

  private

  attr_accessor :popup_window
end
