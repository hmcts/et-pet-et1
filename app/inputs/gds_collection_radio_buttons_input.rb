class GdsCollectionRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def input(_wrapper_options = nil)
    template.content_tag :div, class: 'options' do
      super()
    end
  end
end
