module CarrierwaveFilename
  def for(attachment, underscore: false)
    # @TODO This conditional can be removed once
    file_path = if attachment.is_a?(Hash)
                  attachment['filename']
                else
                  attachment&.file && attachment.file.path
                end
    return unless file_path

    underscore ? underscore_filename_for(file_path) : filename_for(file_path)
  end

  private

  # Jadu API disallows filenames with non alphanumeric
  # characters so we replace them all with underscores.

  def underscore_filename_for(path)
    File.basename(path, '.*').
      gsub(/[^a-zA-Z0-9]/, '_').
      concat(File.extname(path))
  end

  def filename_for(path)
    File.basename(path)
  end

  module_function :for, :underscore_filename_for, :filename_for
end
