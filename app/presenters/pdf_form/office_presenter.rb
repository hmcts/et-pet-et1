class PdfForm::OfficePresenter < PdfForm::BaseDelegator
  def to_h
    {
      "tribunal office" => name
    }
  end
end
