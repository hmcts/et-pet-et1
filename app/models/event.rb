class Event < ApplicationRecord
  CREATED                     = 'created'.freeze
  LOGIN                       = 'login'.freeze
  LOGOUT                      = 'logout'.freeze
  DELIVER_ACCESS_DETAILS      = 'deliver_access_details'.freeze
  FEE_GROUP_REFERENCE_REQUEST = 'fee_group_reference_request'.freeze
  ENQUEUED                    = 'enqueued'.freeze
  RECEIVED_BY_JADU            = 'received_by_jadu'.freeze
  REJECTED_BY_JADU            = 'rejected_by_jadu'.freeze
  CONFIRMATION_EMAIL_SENT     = 'confirmation_email_sent'.freeze
  PAYMENT_RECEIVED            = 'payment_received'.freeze
  PAYMENT_UNCERTAIN           = 'payment_uncertain'.freeze
  PAYMENT_DECLINED            = 'payment_declined'.freeze
  PDF_GENERATED               = 'pdf_generated'.freeze
  MANUAL_STATUS_CHANGE        = 'manual_status_change'.freeze
  MANUALLY_SUBMITTED          = 'manually_submitted'.freeze

  belongs_to :claim

  before_create -> { self[:claim_state] = claim.state }

  alias read_only? persisted?

  default_scope { order(created_at: :desc) }
end
