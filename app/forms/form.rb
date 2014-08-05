class Form
  include ActiveModel::Model

  attr_accessor :resource

  delegate :column_for_attribute, to: :target
  delegate :keys, to: :class

  def resource
    @resource ||= Claim.new
  end

  def self.attributes(*attrs)
    attrs.each do |a|
      define_method(a) { attributes[a] }
      define_method(:"#{a}?") { send(a).present? }
      define_method(:"#{a}=") { |v| attributes[a] = v }
    end
  end

  def self.booleans(*attrs)
    attrs.each do |a|
      define_method(a) { instance_variable_get :"@#{a}" }
      define_method(:"#{a}=") do |v|
        instance_variable_set :"@#{a}", ActiveRecord::ConnectionAdapters::Column.value_to_boolean(v)
      end

      alias_method :"#{a}?", a
    end
  end

  def self.for(name)
    "#{name}_form".classify.constantize
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
  end

  def self.keys
    instance_methods(false).grep(/\A\w+\Z/)
  end

  class << self
    alias_method :boolean, :booleans
    delegate :i18n_key, to: :model_name, prefix: true
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
    @attributes ||= Hash.new do |hash, key|
      if value = respond_to?(:target, true) && target.try(key)
        hash[key] = value
      end
    end
  end

  def save
    if valid?
      target.update_attributes attributes
      resource.save
    end
  end



  private def parse_multiparameter_date_attributes(attributes)
    MultiparameterDateParser.parse(attributes)
  end
end
