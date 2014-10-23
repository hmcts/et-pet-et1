class Respondent < ActiveRecord::Base
  belongs_to :claim
  has_many   :addresses, as: :addressable

  ADDRESS_ATTRIBUTES = %i<building street locality county post_code
                          telephone_number>.flat_map { |a| [a, :"#{a}="] }

  delegate *ADDRESS_ATTRIBUTES, to: :address, prefix: true
  delegate *ADDRESS_ATTRIBUTES, to: :work_address, prefix: true

  before_save :enqueue_fee_group_reference_request,
    if: -> { fee_group_reference_address.try :post_code_changed? }

  def address
    addresses.first
  end

  def work_address
    addresses.second
  end

  def addresses
    association(:addresses).tap do |p|
      (2 - p.count).times { p.build }
    end
  end

  private def fee_group_reference_address
    [work_address, address].find { |a| a.post_code.present? }
  end

  private def enqueue_fee_group_reference_request
    FeeGroupReferenceJob.perform_later claim, fee_group_reference_address.post_code
  end
end
