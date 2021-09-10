require 'open3'
module ContentType
  def of(file)
    Open3.capture2('file', '-b', '--mime', file.path).first.split('; ').first
  end

  module_function :of
end
