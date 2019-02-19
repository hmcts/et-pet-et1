class ConfirmationEmailPresenter < ConfirmationPresenter
  def primary_claimant_full_name
    "#{primary_claimant.first_name} #{primary_claimant.last_name}"
  end

  def text_email_line_break
    @text_email_line_break ||= Array.new(50) { '=' }.join
  end
end
