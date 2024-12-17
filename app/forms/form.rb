class Form < ApplicationRecord
  self.abstract_class = true
  establish_connection adapter: :nulldb,
                       schema: 'config/nulldb_schema.rb'
  attr_reader :resource

  before_validation :clean_strings
  class_attribute :__transient_attributes, default: []
  class_attribute :__custom_mappings, default: {}

  def self.inherited(child)
    child.__transient_attributes = []
    child.__custom_mappings = __custom_mappings.clone
    super
  end

  def initialize(resource, **attrs)
    self.resource = resource
    super(attrs)
    reload
    yield self if block_given?
  end

  def self.transient_attributes(*attrs)
    __transient_attributes.concat attrs unless attrs.empty?
    __transient_attributes
  end

  def self.map_attribute(attribute_name, to:)
    __custom_mappings[attribute_name] = { to: }
  end

  def transient_attributes
    self.class.transient_attributes
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.has_many_forms(collection_name, class_name: "#{collection_name.to_s.singularize.camelize}Form")
    class_eval do
      before_save :"update_#{collection_name}"
      after_save :"#{collection_name}_after_save"
      define_method :"#{collection_name}_proxy" do
        existing = instance_variable_get("@#{collection_name}_proxy")
        return existing unless existing.nil?

        instance_variable_set("@#{collection_name}_proxy", FormCollectionProxy.new(class_name, collection_name, self))
      end

      define_method :"#{collection_name}" do
        send("#{collection_name}_proxy")
      end

      define_method :"#{collection_name}_attributes=" do |attrs|
        send("#{collection_name}_proxy").collection_attributes = attrs
      end

      define_method :"update_#{collection_name}" do
        proxy = send :"#{collection_name}"
        target.attributes = {
          "#{collection_name}_attributes": proxy.collection_attributes
        }
      end

      define_method :"#{collection_name}_after_save" do
        proxy = send :"#{collection_name}"
        proxy.after_save
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Naming/PredicateName

  # Form Methods
  def form_name
    self.class.model_name_i18n_key.to_s.dasherize
  end

  def self.model_name_i18n_key
    model_name.i18n_key
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
  end

  def self.for(name)
    "#{name}_form".classify.constantize
  end

  # This is required as the standard implementation checks the connection to see if the table exists
  # but the connection is the null db adapter, which relies on the schema file to define tables.
  # However, we do not want the table 'definitions' to be defined outside of the form objects
  #
  # If this returns false, then methods dont get defined for the attributes so all attribute accesses use method_missing
  # which is slower and also it means you wont be able to do things like have_attributes in rspec on a form without this
  def self.table_exists?
    true
  end

  # target is normally the resource but can be overriden
  # @TODO - do we need to do this ?
  def target
    resource
  end

  # @TODO This is used to provide a boolean which isn't technically
  # an attribute so doesnt get output to the underlying resource
  def self.boolean(attr)
    define_method(attr) { instance_variable_get :"@#{attr}" }

    type = ActiveRecord::Type::Boolean.new

    define_method(:"#{attr}=") do |v|
      instance_variable_set :"@#{attr}", type.cast(v)
    end

    alias_method :"#{attr}?", attr
  end

  # @TODO This is used just to do multiple booleans !!  (crazy)
  def self.booleans(*attrs)
    attrs.each(&method(:boolean))
  end

  # @TODO Decide whether to change or not
  def self.i18n_scope
    :activemodel
  end

  # @TODO This is for compatibility with old code and is naughty as it is effectively
  # bypassing strong parameters
  # @TODO Work out how to remove this

  # This is to force everything in to thinking we are doing an update all the time ( needed for I18n labels etc.. )
  # @TODO Review if this is really required
  def persisted?
    true
  end

  # Bypasses original save and saves the target
  # @TODO Consider separating persistence from form objects
  # @TODO Why is this calling stuff on target and resource ?
  # rubocop:disable Metrics/AbcSize
  def save
    return false unless valid?

    run_callbacks :save do
      ActiveRecord::Base.transaction do
        mapped_attributes = __custom_mappings.keys.map(&:to_s)
        target.update attributes.except(*(transient_attributes.map(&:to_s) + mapped_attributes)) unless target.frozen?
        write_custom_mappings(__custom_mappings)
        read_custom_mappings(__custom_mappings)
        resource.save
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # Resource methods

  # Loads the form object with values from the target
  def reload
    return if target.nil?

    (attributes.keys - __custom_mappings.keys.map(&:to_s)).each do |key|
      send "#{key}=", target.try(key)
    end
    read_custom_mappings(__custom_mappings)
  end

  private

  attr_writer :resource

  def read_custom_mappings(mappings)
    mappings.each_pair do |attr, options|
      object_to_read_from = options[:to]
      raise "Unknown mapping 'to' method #{object_to_read_from}" unless respond_to?(object_to_read_from)

      send "#{attr}=", send(object_to_read_from).send(attr)
    end
  end

  def write_custom_mappings(mappings)
    mappings.each_pair do |attr, options|
      object_to_write_to = options[:to]
      raise "Unknown mapping 'to' method #{object_to_write_to}" unless respond_to?(object_to_write_to)

      send(object_to_write_to).send("#{attr}=", send(attr))
    end
  end

  def clean_strings
    @attributes.each_value do |attr|
      next unless attr.type.is_a?(ActiveModel::Type::String) && attr.value.is_a?(String)

      if attr.value.frozen?
        attr.value = attr.value.strip
      else
        attr.value.strip!
      end
    end
  end

end
