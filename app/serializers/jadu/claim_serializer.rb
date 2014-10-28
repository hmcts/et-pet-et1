class Jadu::ClaimSerializer < Jadu::BaseSerializer
  present :representative, :payment

  def claimants
    super.map {|claimant| Jadu::ClaimantSerializer.new(claimant)}
  end

  def respondents
    super.map { |respondent| Jadu::RespondentSerializer.new(respondent) }
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
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.ETFeesEntry(
      'xmlns' => "http://www.justice.gov.uk/ETFEES",
      'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
      'xsi:noNamespaceSchemaLocation' => "ETFees_v0.09.xsd") do
      xml.DocumentId do
        xml.DocumentName 'ETFeesEntry'
        xml.UniqueId created_at.to_s(:number)
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
      xml.OfficeCode  office.code
      xml.DateOfReceiptEt submitted_at.xmlschema
      xml.RemissionIndicated remission_indicated
      xml.Administrator('xsi:nil'=>"true")
      xml.Claimants do
        claimants.each{|claimant| claimant.to_xml(options) }
      end
      xml.Respondents do
        respondents.each{|respondent| respondent.to_xml(options) }
      end
      xml.Representatives do
        representative.to_xml(options)
      end
      payment.to_xml(options)
      diversity.to_xml(options)
      xml.Files
    end
  end
end
