class AdditionalInformationPresenter < Presenter
  def miscellaneous_information
    simple_format target.miscellaneous_information
  end

  def attached_document
    additional_information_rtf.to_s.split('/').last
  end
end
