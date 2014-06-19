class Form
  include ActiveModel::Model

  def initialize(attributes={})
    attributes.each { |key, value| send :"#{key}=", value }
  end

  def persisted?
    true
  end

  class << self
    def attributes(*attributes)
      attributes.each { |a| attr_accessor a }
    end

    def model_name
      ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
    end
  end
end
