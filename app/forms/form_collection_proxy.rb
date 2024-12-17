class FormCollectionProxy
  include Enumerable

  def initialize(child_form_class_name, collection_name, parent_form_instance)
    @parent_form_instance = parent_form_instance
    @collection_name = collection_name
    @child_form_klass = child_form_class_name.safe_constantize
    @collection_wrapped = {}
    @collection_cache = []
    @to_destroy = []
    raise "Unknown class #{child_form_class_name}" if child_form_klass.nil?

    on_initialize
  end

  def collection_attributes=(value)
    apply_collection_attributes(value)
  end

  # @return [Hash] Returns the collection attributes to be passed into the target's nested associations code
  def collection_attributes
    attrs = collection_object
    offset = attrs.length
    to_destroy.each_with_object(attrs).with_index do |(form, acc), idx|
      nested_attributes = form_to_nested_attributes(form)
      acc[idx + offset] = nested_attributes unless nested_attributes.empty?
      acc
    end
  end

  def collection_object
    collection_cache.each_with_object({}).with_index do |(form, acc), idx|
      nested_attributes = form_to_nested_attributes(form)
      acc[idx] = nested_attributes unless nested_attributes.empty?
      acc
    end
  end

  def last
    wrapped(collection_cache.last)
  end

  def build(attrs = {})
    child_form_klass.new(nil).tap do |instance|
      instance.attributes = attrs
      collection_cache << instance
    end
  end

  def slice(*args)
    wrap_collection(collection_cache.slice(*args))
  end

  def each(&)
    collection_cache.each(&)
  end

  def clear
    parent_form_resource.send(collection_name).clear
    collection_cache.clear
    to_destroy.clear
    collection_wrapped.clear
  end

  def after_save
    collection_cache.clear
    to_destroy.clear
    load_collection_cache
  end

  delegate_missing_to :collection_cache
  alias to_ary to_a

  private

  attr_reader :parent_form_instance, :collection_name, :child_form_klass, :collection_wrapped, :collection_cache,
              :to_destroy

  def on_initialize
    load_collection_cache
  end

  def load_collection_cache
    parent_form_resource.send(collection_name).each do |entry|
      collection_cache << wrapped(entry).tap(&:clear_changes_information)
    end
  end

  def apply_collection_attributes(collection_attrs)
    collection_attrs.each do |(_key, value)|
      instance = find_or_build_instance(value)
      if ::ActiveRecord::Type::Boolean.new.cast(value["_destroy"])
        mark_for_destruction!(instance)
      else
        instance.attributes = value.except('_destroy', 'id')
      end
    end
  end

  def find_or_build_instance(value)
    if value[child_primary_key].present?
      collection_cache.find do |record|
        record.send(child_primary_key).to_s == value[child_primary_key].to_s
      end
    else
      build
    end
  end

  def form_to_nested_attributes(form)
    if form.marked_for_destruction?
      { child_primary_key => form.send(child_primary_key), '_destroy' => '1' }
    elsif form.target.nil?
      # This was not loaded by the db but has been added since load
      form.attributes.except(child_primary_key.to_s, *child_form_klass.transient_attributes.map(&:to_s))
    else
      form.attributes.slice(*(form.changed_attribute_names_to_save + [child_primary_key]))
    end
  end

  def parent_form_resource
    @parent_form_instance.resource
  end

  def wrap(proxied_object)
    child_form_klass.new(proxied_object)
  end

  def wrapped(proxied_object)
    collection_wrapped.compare_by_identity

    return collection_wrapped[proxied_object] if collection_wrapped.key?(proxied_object)

    collection_wrapped[proxied_object] = wrap(proxied_object)
  end

  def wrap_collection(proxied_collection)
    proxied_collection.map do |proxied_object|
      wrapped(proxied_object)
    end
  end

  def child_primary_key
    @child_primary_key ||= child_form_resource_class.primary_key
  end

  def child_form_resource_class
    @child_form_resource_class ||= parent_form_resource.class.reflect_on_association(collection_name).klass
  end

  def mark_for_destruction!(instance)
    instance.mark_for_destruction
    collection_cache.delete(instance)
    to_destroy << instance
  end
end
