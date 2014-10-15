class AdditionalInformationPresenter < Presenter
  def subsections
    { additional_information: %i<miscellaneous_information attached_document> }
  end

  def miscellaneous_information
    simple_format target.miscellaneous_information
  end

  def attached_document
    attachment.filename
  end
end
