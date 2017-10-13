class Form
  include Core

  attr_accessor :resource

  def initialize(resource, &_block)
    @resource = resource
    reload
    yield self if block_given?
  end

  def persisted?
    true
  end

  def has_attribute?(attr, *args)
    attributes.key?(attr)
  end

  def save
    if valid?
      run_callbacks :save do
        ActiveRecord::Base.transaction do
          target.update_attributes attributes unless target.frozen?
          resource.save
        end
      end
    else
      false
    end
  end

  def target
    resource
  end
end
