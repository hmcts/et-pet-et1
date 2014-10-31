class Jadu::ClaimSerializer < Jadu::BaseSerializer
  present :representative, :payment

  def claimants
    super.map {|claimant| Jadu::ClaimantSerializer.new(claimant) }
  end

  def respondents
    super.map {|respondent| Jadu::RespondentSerializer.new(respondent) }
  end

  def diversity
    Jadu::DiversitySerializer.new nil
  end

  def timestamp
    Time.zone.now
  end

  def case_type
    claimant_count == 1 ? 'Single' : 'Multiple'
  end

  def jurisdiction
    other_claim_details.present? ? 2 : 1
  end

  def remission_indicated
    remission_claimant_count > 0 ? 'Indicated' : 'NotRequested'
  end

  def to_xml(options={})
    xml = builder(options)
    xml.instruct! unless options[:skip_instruct]
    xml.ETFeesEntry(
      'xmlns' => "http://www.justice.gov.uk/ETFEES",
      'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
      'xsi:noNamespaceSchemaLocation' => "ETFees.xsd") do
      xml.DocumentId do
        xml.DocumentName 'ETFeesEntry'
        xml.UniqueId created_at.try(:to_s, :number)
        xml.DocumentType 'ETFeesEntry'
        xml.TimeStamp timestamp.xmlschema
        xml.Version 1
      end
      xml.FeeGroupReference fee_group_reference
      xml.SubmissionUrn id
      xml.CurrentQuantityOfClaimants claimant_count
      xml.SubmissionChannel 'Web'
      xml.CaseType case_type
      xml.Jurisdiction jurisdiction
      xml.OfficeCode '%02d' % office.try(:code)
      xml.DateOfReceiptEt (submitted_at || DateTime.now).xmlschema
      xml.RemissionIndicated remission_indicated
      xml.Administrator('xsi:nil'=>"true")
      build_xml(claimants, options)
      build_xml(respondents, options)
      build_xml([representative], options)
      build_payment_xml(options)
      diversity.to_xml(options)
      xml.Files
    end
  end

  def build_payment_xml(options)
    xml = options[:builder]
    if payment
      payment.to_xml(options)
    elsif options[:without_payment]
      Jadu::PaymentSerializer.new(Payment.new amount: 0, created_at: DateTime.now).to_xml(options)
    end
  end

  def build_xml(collection, options)
    if collection.compact.any?
      options[:builder].tag!(collection.first.pluralized_name) do
        collection.each{|relation| relation.to_xml(options) }
      end
    end
  end
end
