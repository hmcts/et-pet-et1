module Refunds
  class ConfirmationPage < BasePage
    element :reference_number, '[data-behavior=application_reference]'
    element :submitted_date, '[data-behavior=submitted_at]'
  end
end
