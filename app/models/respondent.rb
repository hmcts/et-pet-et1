class Respondent < ActiveRecord::Base
  include JaduFormattable

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
      2.times { p.build } if p.empty?
    end
  end

  private def fee_group_reference_address
    [work_address, address].find { |a| a.post_code.present? }
  end

  private def enqueue_fee_group_reference_request
    FeeGroupReferenceJob.perform_later claim, fee_group_reference_address.post_code
  end

  def primary_respondent?
    self == claim.primary_respondent
  end

  def to_xml(options={})
    require 'builder'
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.Respondent do
      xml.GroupContact primary_respondent?
      xml.Name name
      xml.OfficeNumber address_telephone_number
      xml.PhoneNumber work_address_telephone_number
      xml.Acas do
        xml.Number acas_early_conciliation_certificate_number
        xml.ExemptionCode exemption_code(no_acas_number_reason)
      end
    end
  end
end
