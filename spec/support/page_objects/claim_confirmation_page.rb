require_relative './base_page'
module ET1
  module Test
    class ClaimConfirmationPage < BasePage
      set_url "/en/apply/confirmation"
      # @TODO Refactor this to have some structure - the same as the user sees it
      element :valid_pdf_download, :link_named, 'links.form_submission.valid_pdf_download'
      element :invalid_pdf_download, :link_named, 'links.form_submission.invalid_pdf_download'

      def assert_invalid_pdf_link
        expect(invalid_pdf_download).to be_present
      end

      def assert_office(office)
        # Submitted %{date} to tribunal office %{office} inside a .confirmation-table tr.row td
        # Where date is like '29 September 2014'
        # and office is {Office Name}, {Office Address}
        # code here
      end
    end
  end
end
