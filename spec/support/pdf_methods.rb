module PdfMethods
  def pdf_to_hash(content)
    pdftk = PdfForms.new('pdftk')

    pdf = Tempfile.new('generated_pdf')
    begin
      pdf.write(content)
      pdf.close
      et1_fields = pdftk.get_fields(pdf)
      hash = et1_fields.map{|field| [field.name, treat_blank_as_nil(field.value)]}.to_h
    ensure
      pdf.close
      pdf.unlink
    end

    hash
  end

  def treat_blank_as_nil(value)
    value if value.present?
  end
end
