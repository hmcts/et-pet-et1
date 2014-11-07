class Form
  include ActiveModel::Model
  extend  ActiveModel::Callbacks
  include Virtus.model

  attr_accessor :resource

  define_model_callbacks :save, :validation

  delegate :keys, to: :class

  # Allows SimpleForm to reason about types
  def column_for_attribute(attr)
    if attribute_set[attr]
      OpenStruct.new type: attribute_set[attr].type.to_s.demodulize.downcase.to_sym
    end
  end

  class << self
    def attribute(attribute, klass, options={})
      super
      define_method("#{attribute}?") { send(attribute).present? }
    end

    def booleans(*attrs)
      attrs.each do |a|
        define_method(a) { instance_variable_get :"@#{a}" }

        type = ActiveRecord::Type::Boolean.new

        define_method(:"#{a}=") do |v|
          instance_variable_set :"@#{a}", type.type_cast_from_user(v)
        end

        alias_method :"#{a}?", a
      end
    end

    def dates(*dates)
      dates.each do |date|
        validates date, date: true

        # Virtus doesn't know how to cast ActionController::Parameters or hashes
        # with stringified keys. It will obviously fail to cast a Hash with blank values
        # which we need to handle because of the GDS date pattern

        define_method("#{date}=") do |obj|
          if obj.respond_to?(:symbolize_keys)
            super obj.symbolize_keys if obj.values.any?(&:present?)
          else
            super obj
          end
        end
      end
    end

    def for(name)
      "#{name}_form".classify.constantize
    end

    def model_name
      ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
    end

    alias_method :boolean, :booleans
    delegate :i18n_key, to: :model_name, prefix: true
  end

  def initialize(resource, &block)
    @resource = resource
    reload
    yield self if block_given?
  end

  def assign_attributes(attributes={})
    attributes.each { |key, value| send :"#{key}=", value }
  end

  def persisted?
    true
  end

  def valid?
    run_callbacks(:validation) { super }
  end

  def save
    if valid?
      run_callbacks :save do
        target.update_attributes attributes unless target.frozen?
        resource.save
      end
    else
      false
    end
  end

  def reload
    attributes.each_key { |key| send "#{key}=", target.send(key) }
  end

  def target
    resource
  end
end
