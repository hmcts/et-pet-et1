module CarrierwaveFilename
  def for(attachment, underscore: false)
    file = attachment.file && attachment.file.path.split('/').last

    underscore ? replace_non_alphanumerics_for(file) : file
  end

  # Jadu API disallows filenames with non alpha numeric
  # characters so we replace them all with underscores.
  # The regex uses a lookahead to avoid replacing the last non alnum
  # as this will be a '.' and is required to separate the name
  # from the file extension
  private def replace_non_alphanumerics_for(filename)
    filename.gsub(/[^a-zA-Z0-9](?=[[:alnum:]]*\.)/, '_')
  end

  extend self
end
