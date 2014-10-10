class GuidePresenter
  attr_reader :file_names

  def initialize(directory, file_names, renderer)
    @directory = directory
    @file_names = file_names
    @renderer = renderer
  end

  def each_file(&block)
    file_names.each do |name|
      html_output = render(name)
      yield(html_output, name)
    end
  end

  private

  def render(file)
    @renderer.render( contents_of file )
  end

  def contents_of(file)
    File.read("#{ @directory + file }.md")
  end
end