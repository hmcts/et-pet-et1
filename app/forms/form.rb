class Form
  include ActiveModel::Model

  attr_accessor :resource

  class << self
    private def attributes(*attrs)
      attrs.each do |a|
        define_method(a) { attributes[a] }
        define_method(:"#{a}?") { attributes[a].present? }
        define_method(:"#{a}=") { |v| attributes[a] = v }
      end
    end

    def for(name)
      "#{name}_form".classify.constantize
    end

    def model_name
      ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
    end
  end

  def initialize(attributes={},&block)
    assign_attributes attributes
    yield self if block_given?
  end

  def assign_attributes(attributes={})
    parse_multiparameter_date_attributes(attributes)
      .each { |key, value| send :"#{key}=", value }
  end

  def persisted?
    true
  end

  def attributes
    @attributes ||= {}
  end

  def save
    if valid?
      resource.update_attributes attributes
    end
  end

  private def parse_multiparameter_date_attributes(attributes)
    MultiparameterDateParser.parse(attributes)
  end
end
