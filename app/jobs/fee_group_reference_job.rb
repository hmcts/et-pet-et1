class FeeGroupReferenceJob < ActiveJob::Base
  include EtBaseJob
  queue_as :fee_group_reference

  def perform(claim, postcode)
    fee_group_reference = FeeGroupReference.create postcode: postcode
    claim.create_event Event::FEE_GROUP_REFERENCE_REQUEST
    claim.update! fee_group_reference: fee_group_reference.reference
    claim.create_office!(
      code:      fee_group_reference.office_code,
      name:      fee_group_reference.office_name,
      address:   fee_group_reference.office_address,
      telephone: fee_group_reference.office_telephone)
  end
end
