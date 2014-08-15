class Presenter
  include ActionView::Helpers

  # class NullObjectProxy# < BasicObject
  #   def initialize(target)
  #     @target = target
  #   end
  #
  #   def method_missing(meth, *args, &blk)
  #     if @target.respond_to? meth
  #       @target.send(meth)
  #     elsif @target
  #       super
  #     else
  #       nil
  #     end
  #   end
  #
  #   def respond_to_missing? method_name, include_private=false
  #     true
  #   end
  # end

  attr_reader :target

  def initialize(target)
    @target = target
  end

  def self.present *keys
    keys.each { |key| delegate key, to: :target, allow_nil: true }
  end

  def self.for(name)
    "#{name}_presenter".classify.constantize
  end

  def each
    self.class.instance_methods(false).each { |attr| proc[attr, send(attr)] }
  end

  def label_for key
    I18n.t "presenters.#{self.class.name.underscore.sub(/_presenter\Z/, '')}.#{key}"
  end

  private

  def method_missing meth, *args, &block
    if target.respond_to? meth
      singleton_class.instance_eval do
        define_method(meth) { target.send meth }
      end

      send meth
    else
      super
    end
  end

  def respond_to_missing? method_name, include_private=false
    target.respond_to? method_name, include_private
  end

  def yes_no(val)
    I18n.t "simple_form.#{val ? 'yes' : 'no'}" unless val.nil?
  end

  def date(date)
    date.try :strftime, '%d/%m/%Y'
  end

  def simple_format(value)
    super value if value.present?
  end
end
