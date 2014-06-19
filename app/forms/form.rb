class Form
  include ActiveModel::Model

  def initialize(attrs={})
    attrs.each do |key, value|
      singleton_class.send :attr_accessor, key
      send :"#{key}=", value
    end
  end

  class << self
    def model_name
      name.underscore.sub /_form\Z/, ''
    end
  end
end
