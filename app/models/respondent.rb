class Respondent < ActiveRecord::Base
  belongs_to :claim
  has_many   :addresses, as: :addressable, autosave: true

  ADDRESS_ATTRIBUTES = %i[building street locality county post_code
                          telephone_number].flat_map { |a| [a, :"#{a}="] }

  delegate(*ADDRESS_ATTRIBUTES, to: :address, prefix: true)
  delegate(*ADDRESS_ATTRIBUTES, to: :work_address, prefix: true)

  before_save :enqueue_fee_group_reference_request, if: :needs_fee_group_reference?

  def address
    addresses.detect(&:primary?) || addresses.build(primary: true)
  end

  def work_address
    addresses.reject(&:primary?).first || addresses.build(primary: false)
  end

  private

  def fee_group_reference_address
    [work_address, address].find { |a| a.post_code.present? }
  end

  def enqueue_fee_group_reference_request
    FeeGroupReferenceJob.perform_later claim, fee_group_reference_address.post_code
  end

  delegate :post_code_changed?, to: :fee_group_reference_address, allow_nil: true, prefix: true

  def needs_fee_group_reference?
    primary_respondent? && fee_group_reference_address_post_code_changed?
  end
end
