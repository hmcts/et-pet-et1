class SimpleForm::FormBuilder
  map_type :radio_buttons, to: ::GdsCollectionRadioButtonsInput
  map_type :date,          to: ::KnowDateInput
end

module SimpleForm
  module Tags
    class CollectionRadioButtons
      def render(&block)
        super do |b|
          b.radio_button(data_options(b)) + b.text
        end
      end

      def data_options(builder)
        if @options[:reveal]
          key = builder.object.last
          { "data-target" => @options[:reveal][key] }
        else
          {}
        end
      end
    end
  end
end
