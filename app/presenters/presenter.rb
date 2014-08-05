class Presenter < Struct.new(:target)
  include ActionView::Helpers

  def self.present *keys
    keys.each { |key| delegate key, to: :target }
  end

  def self.for(name)
    "#{name}_presenter".classify.constantize
  end

  def each
    self.class.instance_methods(false).each { |attr| proc[attr] }
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
    I18n.t "simple_form.#{val ? 'yes' : 'no'}"
  end

  def date(date)
    date.try :strftime, '%d/%m/%Y'
  end
end
