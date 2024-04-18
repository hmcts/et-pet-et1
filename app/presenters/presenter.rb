class Presenter
  include ActionView::Helpers

  attr_accessor :target

  # If a target is nil we want the presenter to still be able to send messages
  # to the target and just return nil. This way we get "Not entered" instead of
  # a 500. This should never happen but could if a user ends up on the review page
  # by manually entering the URL before completing all form pages

  class NullObject < BasicObject
    def method_missing(*)
      nil
    end

    def respond_to?(*)
      true
    end
  end

  def initialize(target)
    @target = target || NullObject.new
  end

  def self.present(*keys)
    keys.each { |key| delegate key, to: :target, allow_nil: true }
  end

  def self.i18n_key
    name.underscore.sub(/_presenter\Z/, '')
  end

  def each_item
    items.each do |meth|
      yield(meth, send(meth))
    end
  end

  private

  def items
    self.class.instance_methods(false)
  end

  def method_missing(meth, *args, &block)
    if target.respond_to? meth
      singleton_class.instance_eval do
        define_method(meth) { target.send meth }
      end

      send meth
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    target.respond_to? method_name, include_private
  end

  def yes_no(val)
    return if val.nil?

    I18n.t "shared.#{val ? 'yes' : 'no'}"
  end

  def date(date)
    return unless date

    I18n.l date, format: '%d %B %Y'
  end

  def simple_format(value)
    super value if value.present?
  end
end
