class SimpleForm::FormBuilder
  map_type :radio_buttons, to: ::GdsCollectionRadioButtonsInput
  map_type :date,          to: ::KnowDateInput
end

module SimpleForm
  module Tags
    class CollectionRadioButtons
      def render_collection
        @template_object.content_tag :div, class: "option" do
          super
        end
      end
    end
  end
end
