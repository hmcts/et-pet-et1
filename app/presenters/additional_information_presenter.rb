class AdditionalInformationPresenter < Presenter
  def miscellaneous_information
    simple_format target.miscellaneous_information
  end

  def attached_document
    CarrierwaveFilename.for additional_information_rtf
  end
end
