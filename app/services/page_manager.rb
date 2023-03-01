class PageManager
  Page = Struct.new(:name, :number, :transitions_to, :skip_to, :namespace)

  class << self
    def pages
      @pages ||= []
    end

    def page(name, config = {})
      pages << Page.new(name, *config.values_at(:number, :transitions_to, :skip_to))
    end

    def first_page
      @pages.first.name
    end

    def second_page
      @pages.second.name
    end

    def page_names
      @pages.map(&:name)
    end

    def namespace(name = nil)
      return @namespace if name.nil?

      @namespace = name
    end
  end

  def initialize(resource:)
    @resource = resource
  end

  def forward
    page.transitions_to
  end

  def skip
    page.skip_to
  end

  def current_page
    page.number
  end

  def total_pages
    self.class.pages.map(&:number).compact.uniq.size
  end

  private def page
    @page ||= self.class.pages.find do |p|
      if self.class.namespace.nil?
        p.name == @resource.form_name
      else
        [self.class.namespace, p.name].join('/') == @resource.form_name
      end
    end
  end
end
