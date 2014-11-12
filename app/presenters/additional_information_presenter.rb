class AdditionalInformationPresenter < Presenter
  def miscellaneous_information
    simple_format target.miscellaneous_information
  end

  def attached_document
    attachment.to_s.split('/').last
  end
end
