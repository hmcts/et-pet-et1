RSpec.shared_examples 'google tag manager' do |page_object_class:|
  subject(:page_object) { page_object_class.new.tap(&:load) }

  let(:page_object_class) { page_object_class }

  context 'google tag manager', js: false do
    context 'with account' do
      around do |example|
        old = Rails.configuration.google_tag_manager_account
        Rails.configuration.google_tag_manager_account = "dummyaccount"
        example.run
      ensure
        Rails.configuration.google_tag_manager_account = old
      end
      it 'has google tag manager script and noscript tags' do
        expect(page_object).to be_displayed.and have_google_tag_manager_sections_for("dummyaccount")
      end
    end
    context 'without account' do
      around do |example|
        old = Rails.configuration.google_tag_manager_account
        Rails.configuration.google_tag_manager_account = false
        example.run
      ensure
        Rails.configuration.google_tag_manager_account = old
      end
      it 'has no google tag manager script or noscript tags' do
        expect(page_object).to be_displayed.and have_no_google_tag_manager_sections
      end
    end
  end
end
