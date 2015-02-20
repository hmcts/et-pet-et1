module JaduXml
  class ClaimPresenter < XmlPresenter
    self.representation_wrap = "ETFeesEntry"

    node_attribute :xmlns, as: "xmlns", value: "http://www.justice.gov.uk/ETFEES"
    node_attribute :xsi, as: "xmlns:xsi", value: "http://www.w3.org/2001/XMLSchema-instance"
    node_attribute :location, as: "xsi:noNamespaceSchemaLocation", value: "ETFees_v0.20.xsd"

    property :document_id, extend: JaduXml::DocumentIdPresenter, exec_context: :decorator
    property :fee_group_reference, as: "FeeGroupReference", render_nil: true
    property :reference, as: "SubmissionUrn"
    property :claimant_count, as: "CurrentQuantityOfClaimants"
    property :submission_channel, as: "SubmissionChannel", exec_context: :decorator
    property :case_type, as: "CaseType", exec_context: :decorator
    property :jurisdiction, as: "Jurisdiction", exec_context: :decorator
    property :office_code, as: "OfficeCode", exec_context: :decorator, render_nil: true
    property :date_of_receipt, as: "DateOfReceiptEt", exec_context: :decorator
    property :remission_indicated, as: "RemissionIndicated", exec_context: :decorator
    property :administrator, as: "Administrator", exec_context: :decorator

    collection :claimants, extend: JaduXml::ClaimantPresenter,
      class: Claimant, wrap: "Claimants", exec_context: :decorator

    collection :respondents, extend: JaduXml::RespondentPresenter,
      class: Respondent, wrap: "Respondents"

    collection :representative, extend: JaduXml::RepresentativePresenter,
      exec_context: :decorator, render_empty: true, wrap: "Representatives"

    property :payment, extend: JaduXml::PaymentPresenter, exec_context: :decorator

    collection :files, extend: JaduXml::FilePresenter,
      exec_context: :decorator, render_empty: true, wrap: "Files"

    delegate :claimant_count, :other_claim_details, :office, :submitted_at,
      :remission_claimant_count, :representative, :attachments,
      :attracts_higher_fee?, to: :represented

    delegate :code, to: :office, prefix: true, allow_nil: true

    def claimants
      AdditionalClaimantsCsv::ClaimantCollection.new(represented).prepare
    end

    def document_id
      represented
    end

    def submission_channel
      "Web"
    end

    def case_type
      claimant_count == 1 ? "Single" : "Multiple"
    end

    def jurisdiction
      attracts_higher_fee? ? 2 : 1
    end

    def date_of_receipt
      submitted_at.xmlschema
    end

    def remission_indicated
      remission_claimant_count.zero? ? "NotRequested" : "Indicated"
    end

    def administrator
      -1
    end

    def representative
      Array(represented.representative)
    end

    def payment
      represented
    end

    def files
      attachments
    end
  end
end
