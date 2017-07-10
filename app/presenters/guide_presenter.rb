class GuidePresenter
  def initialize(file_paths, renderer)
    @files = file_paths
    @renderer = renderer
  end

  def each_rendered_file(&_block)
    @files.each do |file|
      html_output = render(file)
      basename = file_name_without_extension(file)
      yield(basename, html_output)
    end
  end

  def file_names
    @files.map { |file| file_name_without_extension(file) }
  end

  private

  def file_name_without_extension(file)
    File.basename(file).split(".").first
  end

  def render(file)
    @renderer.render(contents_of(file))
  end

  def contents_of(file_path)
    File.read file_path
  end
end
