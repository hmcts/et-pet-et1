module Refunds
  class ConfirmationForm < Form
    attribute :application_reference,  String
    attribute :submitted_at,         Date
  end
end
