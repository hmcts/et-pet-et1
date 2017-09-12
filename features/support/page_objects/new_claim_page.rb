class NewClaimPage < BasePage
  set_url '/'

  section :content, '#content' do

    section :main_section, '.main-section' do
      section :main_content, '.main-content' do
        element :start_a_claim, 'input[value="Start a claim"]'
      end
    end
  end
  delegate :start_a_claim, to: "content.main_section.main_content"
end
