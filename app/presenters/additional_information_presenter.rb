class AdditionalInformationPresenter < Presenter
  def miscellaneous_information
    simple_format target.miscellaneous_information
  end
end
