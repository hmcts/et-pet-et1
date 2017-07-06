module SimpleForm
  module Inputs
    class CollectionInput < Base
      def translate_collection
        translated_collection = translate_from_namespace(:options)
        return false unless translated_collection

        @collection = collection.map { |key| translate_for_key(translated_collection, key) }
        true
      end

      def detect_common_display_methods(collection_classes = detect_collection_classes)
        if collection_classess_match?(collection_classes)
          collection_translated = translate_collection
        end

        if collection_translated || collection_classes.include?(Array)
          { label: :first, value: :second }
        elsif collection_includes_basic_objects?(collection_classes)
          { label: :to_s, value: :to_s }
        else
          detect_method_from_class(collection_classes)
        end
      end

      private

      def translate_for_key(translated_collection, key)
        html_key = "#{key}_html".to_sym
        if translated_collection[html_key]
          [translated_collection[html_key] || key, key.to_s]
        else
          [translated_collection[key.to_sym] || key, key.to_s]
        end
      end

      def collection_classess_match?(collection_classes)
        collection_classes.all? { |c| c == Symbol || c == String }
      end
    end
  end
end
