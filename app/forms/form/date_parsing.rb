class Form
  module DateParsing
    extend ActiveSupport::Concern

    included do
      class << self
        def dates(*dates)
          dates.each do |date|
            validates date, date: true

            # Virtus doesn't know how to cast ActionController::Parameters or hashes
            # with stringified keys. It will obviously fail to cast a Hash with blank values
            # which we need to handle because of the GDS date pattern

            define_method("#{date}=") do |obj|
              obj = obj.to_unsafe_hash if obj.respond_to?(:to_unsafe_hash)
              begin
                super coerce_object(obj)
              rescue ArgumentError
                # Handle invalid dates such as 22-54-2010
                instance_variable_set :"@#{date}", obj
              end
            end
          end
        end
      end

      private

      def coerce_object(obj)
        if obj.respond_to?(:symbolize_keys)
          obj.symbolize_keys if obj.values.any?(&:present?)
        else
          obj
        end
      end
    end
  end
end
