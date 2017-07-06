require 'cgi'
require 'forwardable'
require 'securerandom'
require 'net/http'

module Multipart
  CRLF = "\r\n".freeze

  class Post < Net::HTTP::Post
    def initialize(path, *params)
      super path
      set_content_type 'multipart/form-data', 'boundary' => boundary
      self.body = (rendered_params(params) + coda).join(CRLF)
    end

    private

    def rendered_params(params)
      params.flat_map { |p| ["--#{boundary}", p.to_multipart] }
    end

    def boundary
      @boundary ||= SecureRandom.hex
    end

    def coda
      ["--#{boundary}--", '']
    end
  end

  class ParamHeader
    extend Forwardable
    def_delegator :CGI, :escape

    def initialize(name, value, options = {})
      @name = name
      @value = value
      @options = options
    end

    def render
      ([rendered_name_and_value] + rendered_options).join('; ')
    end

    private

    def rendered_name_and_value
      '%s: %s' % [@name, @value]
    end

    def rendered_options
      @options.map { |k, v| '%s="%s"' % [escape(k), escape(v)] }
    end
  end

  class RawContent
    def initialize(raw)
      @render = raw
    end

    attr_reader :render
  end

  module ParamGeneration
    def header(name, value, options = {})
      ParamHeader.new(name, value, options)
    end

    def blank_line
      RawContent.new('')
    end

    def raw_content(a)
      RawContent.new(a)
    end

    def render_lines(*lines)
      lines.map(&:render).join(CRLF)
    end

    def ==(other)
      to_multipart == other.to_multipart
    end
  end

  class StringParam
    include ParamGeneration

    def initialize(name, content)
      @options = { 'name' => name }
      @content = content
    end

    def to_multipart
      render_lines(
        header('Content-Disposition', 'form-data', @options),
        blank_line,
        raw_content(@content)
      )
    end
  end

  class FileParam
    include ParamGeneration

    def initialize(name, filename, content)
      @options = { 'name' => name, 'filename' => filename }
      @content = content
    end

    def to_multipart
      render_lines(
        header('Content-Disposition', 'form-data', @options),
        header('Content-Type', 'application/octet-stream'),
        blank_line,
        raw_content(@content)
      )
    end
  end
end
