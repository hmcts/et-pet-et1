module ContentType
  def of(file)
    `file -b --mime #{file.path}`.split('; ').first
  end

  module_function :of
end
