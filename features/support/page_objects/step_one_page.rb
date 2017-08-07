class StepOnePage < BasePage

  section :content, '#content' do

    section :main_section, '.main-section' do
      section :main_content, '.main-content' do
        element :email, 'input[name="application_number[email_address]"]'
        element :memorable_word, 'input[name="application_number[password]"]'
        element :save_and_continue, 'input[value="Save and continue"]'
      end
    end
  end
  delegate :email, :memorable_word, :save_and_continue, to: "content.main_section.main_content"
end
