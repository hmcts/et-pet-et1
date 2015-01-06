module CarrierwaveFilename
  def for(attachment)
    attachment.file.path.split('/').last if attachment.file
  end

  extend self
end
