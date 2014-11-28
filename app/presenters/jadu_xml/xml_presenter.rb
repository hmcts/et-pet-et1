module JaduXml
  class XmlPresenter < Representable::Decorator
    include Representable::XML

    def self.inherited(base)
      base.representation_wrap = base.name.match(/::(.*)Presenter$/)[1]
    end

    def self.node_attribute(name, options)
      define_method(name) { options[:value] }
      property name, as: options[:as], attribute: true, exec_context: :decorator
    end
  end
end
