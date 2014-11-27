module ClaimConfirmationsHelper
  def confirmation_presenter
    @confirmation_presenter ||= ConfirmationPresenter.new claim
  end
end
