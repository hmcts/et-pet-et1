class Form
  include ActiveModel::Model
  include ActiveSupport::Callbacks

  ADDRESS_LINE_LENGTH  = 75
  EMAIL_ADDRESS_LENGTH = 100
  LOCALITY_LENGTH      = 25
  NAME_LENGTH          = 100
  PHONE_NUMBER_LENGTH  = 21
  POSTCODE_LENGTH      = 8

  attr_accessor :resource, :target

  define_callbacks :save

  %i<before after>.each do |event|
    define_singleton_method "#{ event }_save" do |callback|
      set_callback(:save, event, callback)
    end
  end

  before_save :clear_irrelevant_fields
  def clear_irrelevant_fields
  end

  # TODO smarter delegation of this method to take into account delegated
  # attributes, e.g. the ones on address
  def column_for_attribute *args
    ActiveSupport::Deprecation.silence do
      target.column_for_attribute *args
    end
  end

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

      type = ActiveRecord::Type::Boolean.new

      define_method(:"#{a}=") do |v|
        instance_variable_set :"@#{a}", type.type_cast_from_user(v)
      end

      alias_method :"#{a}?", a
    end
  end

  def self.dates(*attrs)
    attrs.each { |attribute| date attribute }
  end

  def self.date(attribute)
    validates attribute, date: true
    MultiParameterDate.decorate self, attribute
  end

  def self.for(name)
    "#{name}_form".classify.constantize
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
  end

  class << self
    alias_method :boolean, :booleans
    delegate :i18n_key, to: :model_name, prefix: true
  end

  def initialize(attributes={}, &block)
    assign_attributes attributes
    yield self if block_given?
  end

  def assign_attributes(attributes={})
    attributes.each { |key, value| send :"#{key}=", value }
  end

  def persisted?
    true
  end

  def attributes
    @attributes ||= Hash.new do |hash, key|
      if respond_to?(:target, true) && !target.try(key).nil?
        hash[key] = target.try key
      end
    end
  end

  def save
    if valid?
      run_callbacks :save do
        target.update_attributes attributes
        resource.save
      end
    else
      false
    end
  end
end
