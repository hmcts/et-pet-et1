
require_relative './base_page'
module ET1
  module Test
    class SubmissionPage < BasePage

      element :submit_claim, 'form.new_confirmation_email input[value="Submit claim"]'
    end

  end
end
