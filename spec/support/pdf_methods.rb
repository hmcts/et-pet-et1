module PdfMethods
  def pdf_to_hash(content)
    pdftk = PdfForms.new('/usr/local/bin/pdftk')

    pdf = Tempfile.new('generated_pdf')
    begin
      pdf.write(content)
      pdf.close
      et1_fields = pdftk.get_fields(pdf)
      hash = et1_fields.map{|field| [field.name, field.value]}.to_h
    ensure
       pdf.close
       pdf.unlink
    end

    hash
  end
end
