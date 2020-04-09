class Event < ApplicationRecord
  CREATED                     = 'created'.freeze
  LOGIN                       = 'login'.freeze
  LOGOUT                      = 'logout'.freeze
  DELIVER_ACCESS_DETAILS      = 'deliver_access_details'.freeze
  MANUAL_STATUS_CHANGE        = 'manual_status_change'.freeze
  MANUALLY_SUBMITTED          = 'manually_submitted'.freeze

  belongs_to :claim

  before_create -> { self[:claim_state] = claim.state }

  alias read_only? persisted?

  default_scope { order(created_at: :desc) }
end
