class FeeGroupReferenceJob < ActiveJob::Base
  queue_as :fee_group_reference

  def perform(claim, postcode)
    fee_group_reference = FeeGroupReference.create postcode: postcode
    claim.update! fee_group_reference: fee_group_reference.reference
  end
end
