class CollectionForm < Form
  boolean :has_collection

  before_validation :reset_collection!, unless: :has_collection

  class << self
    def resource(klass=nil)
      if klass
        @resource = klass
      else
        @resource
      end
    end
  end

  def has_collection
    if defined? @has_collection
      @has_collection
    else
      @has_collection = relation.any? &:persisted?
    end
  end

  def collection_attributes=(attributes)
    attributes.each_with_index do |(_, resource_attributes), index|
      resource = relation[index] || relation.build

      collection[index] = self.class.resource.new(resource) do |c|
        c.assign_attributes resource_attributes
      end
    end
  end

  def collection
    @collection ||= relation.tap { |c| c.build if c.empty? }.map { |c| self.class.resource.new(c) }
  end

  def build_child
    @collection << self.class.resource.new(relation.build)
  end

  def save
    if valid?
      run_callbacks(:save) do
        ActiveRecord::Base.transaction do
          resource.save
          collection.all?(&:save)
        end
      end
    else
      false
    end
  end

  def valid?
    run_callbacks(:validation) { super && collection.map(&:valid?).all? }
  end

  def errors
    collection.each_with_object(super) do |resource, errors|
      errors.add(:collection, resource.errors)
    end
  end

  private

  def relation
    resource.send "secondary_#{resource_name}"
  end

  def reset_collection!
    relation.destroy_all
    collection.clear
  end

  def resource_name
    self.class.resource.name.underscore.match(/\Aadditional_(\w+)_form\/\w+\Z/)[1]
  end
end
