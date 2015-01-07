module CarrierwaveFilename
  def for(attachment, underscore: false)
    file = attachment.file && attachment.file.path.split('/').last

    underscore ? file.tr('-', '_') : file
  end

  extend self
end
