class Form
  module Core
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model
      extend  ActiveModel::Callbacks

      include DateParsing
      include Virtus.model

      define_model_callbacks :save, :validation
      delegate :keys, to: :class

      # Allows SimpleForm to reason about types
      def column_for_attribute(attr)
        if attribute_set[attr]
          OpenStruct.new type: attribute_set[attr].type.to_s.demodulize.downcase.to_sym
        end
      end

      def assign_attributes(attributes={})
        attributes.each { |key, value| send :"#{key}=", value }
      end

      def valid?
        run_callbacks(:validation) { super }
      end

      def reload
        attributes.each_key { |key| send "#{key}=", target.send(key) }
      end

      def form_name
        self.class.model_name_i18n_key.to_s.dasherize
      end

      class << self
        def attribute(attribute, klass, options={})
          super
          define_method("#{attribute}?") { send(attribute).present? }
        end

        def booleans(*attrs)
          attrs.each do |a|
            define_method(a) { instance_variable_get :"@#{a}" }

            type = ActiveRecord::Type::Boolean.new

            define_method(:"#{a}=") do |v|
              instance_variable_set :"@#{a}", type.type_cast_from_user(v)
            end

            alias_method :"#{a}?", a
          end
        end

        def for(name)
          "#{name}_form".classify.constantize
        end

        def model_name
          ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
        end

        alias_method :boolean, :booleans
        delegate :i18n_key, to: :model_name, prefix: true
      end
    end
  end
end
