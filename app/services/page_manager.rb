class PageManager
  class << self
    def pages
      @pages ||= []
    end

    def page(page_config)
      self.pages << OpenStruct.new(page_config)
    end

    def first_page
      @pages.first.name
    end

    def page_names
      @pages.map(&:name)
    end
  end

  def initialize(resource:)
    @resource = resource
  end

  def forward
    page.transitions_to
  end

  def current_page
    page.number
  end

  def total_pages
    self.class.pages.map(&:number).compact.uniq.size
  end

  private def page
    @page ||= self.class.pages.find { |p| p.name == @resource.form_name }
  end
end
