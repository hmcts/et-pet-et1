class Event < ActiveRecord::Base
  CREATED                     = 'created'.freeze
  LOGIN                       = 'login'.freeze
  LOGOUT                      = 'logout'.freeze
  DELIVER_ACCESS_DETAILS      = 'deliver_access_details'.freeze
  FEE_GROUP_REFERENCE_REQUEST = 'fee_group_reference_request'
  ENQUEUED                    = 'enqueued'.freeze
  RECEIVED_BY_JADU            = 'received_by_jadu'.freeze
  REJECTED_BY_JADU            = 'rejected_by_jadu'.freeze
  CONFIRMATION_EMAIL_SENT     = 'confirmation_email_sent'.freeze
  PAYMENT_RECEIVED            = 'payment_received'.freeze
  PAYMENT_UNCERTAIN           = 'payment_uncertain'.freeze
  PAYMENT_DECLINED            = 'payment_declined'.freeze
  PDF_GENERATED               = 'pdf_generated'.freeze
  ADMIN_CHANGE                = 'changed_by_admin'.freeze
  ADMIN_SUBMITTED             = 'submitted_by_admin'.freeze

  belongs_to :claim

  before_create -> { self[:claim_state] = claim.state }

  alias_method :read_only?, :persisted?

  default_scope { order(created_at: :desc) }
end
