class Presenter
  include ActionView::Helpers

  class Proxy
    def initialize(target)
      @target = target
    end

    def method_missing(meth, *args, &blk)
      if @target.respond_to? meth
        @target.send(meth)
      elsif @target
        super
      else
        nil
      end
    end

    def respond_to_missing? method_name, include_private=false
      if @target
        @target.respond_to? method_name, include_private
      else
        true
      end
    end
  end

  attr_reader :target

  def initialize(target)
    @target = Proxy.new target
  end

  def self.present *keys
    keys.each { |key| delegate key, to: :target, allow_nil: true }
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
    unless val.nil?
      I18n.t "simple_form.#{val ? 'yes' : 'no'}"
    end
  end

  def date(date)
    date.try :strftime, '%d/%m/%Y'
  end

  def simple_format(value)
    super value if value.present?
  end
end
