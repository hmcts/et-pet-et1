class Form
  include ActiveModel::Model

  attr_accessor :resource

  class << self
    def for(name)
      "#{name}_form".classify.constantize
    end
  end

  def initialize(attributes={})
    assign_attributes attributes
  end

  def assign_attributes(attributes={})
    attributes.each { |key, value| send :"#{key}=", value }
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

  class << self
    def attributes(*attrs)
      attrs.each do |a|
        define_method(a) { attributes[a] }
        define_method(:"#{a}=") { |v| attributes[a] = v }
      end
    end

    def model_name
      ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
    end
  end
end
