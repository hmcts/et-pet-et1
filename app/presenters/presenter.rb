class Presenter < Struct.new(:target)
  include ActionView::Helpers

  def self.present(*keys)
    keys.each { |key| delegate key, to: :target, allow_nil: true }
  end

  def each_item
    items.each { |meth| proc[meth, send(meth)] }
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

  def respond_to_missing?(method_name, include_private=false)
    target.respond_to? method_name, include_private
  end

  def yes_no(val)
    unless val.nil?
      I18n.t "simple_form.#{val ? 'yes' : 'no'}"
    end
  end

  def date(date)
    date.try :strftime, '%d %B %Y'
  end

  def simple_format(value)
    super value if value.present?
  end
end
