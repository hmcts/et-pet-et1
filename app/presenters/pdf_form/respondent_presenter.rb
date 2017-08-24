class PdfForm::RespondentPresenter < PdfForm::BaseDelegator
  RESPONDENT_FIELDS = [
    [
      "2.1",
      "2.2 number",
      "2.2 street",
      "2.2 town city",
      "2.2 county",
      "2.2 phone number",
      "2.2 postcode"
    ], [
      "2.4 R2 name",
      "2.4 R2 number",
      "2.4 R2 street",
      "2.4 R2 town",
      "2.4 R2 county",
      "2.4 R2 phone number",
      "2.4 R2 postcode"
    ], [
      "2.4 R3 name",
      "2.4 R3 number",
      "2.4 R3 street",
      "2.4 R3 town city",
      "2.4 R3 county",
      "2.4 R3 phone number",
      "2.4 R3 postcode"
    ], [
      "13 R4 name",
      "13 R4 number",
      "13 R4 street",
      "13 R4 town city",
      "13 R4 county",
      "13 R4 phone number",
      "13 R4 postcode"
    ], [
      "13 R5 name",
      "13 R5 number",
      "R5 street",
      "R5 town city",
      "R5 county",
      "R5 phone number",
      "R5 postcode"
    ]
  ].freeze

  HAS_ACAS_CHECKBOXES = [
    "Check Box1", "Check Box8", "Check Box15", "Check Box22", "Check Box29"
  ].freeze

  ACAS_NUMBER_FIELDS = ['Text2', 'Text9', 'Text16', 'Text23', 'Text30'].freeze

  def initialize(respondent, index)
    super(respondent)
    @index = index
  end

  def to_h
    hash = {}
    keys = RESPONDENT_FIELDS[@index]

    hash.update work_address_hash if first_respondent?
    hash.update keys.zip(values).to_h
    hash.update acas_hash
  end

  private

  def values
    [name, address_building, address_street, address_locality, address_county,
     address_telephone_number, format_postcode(address_post_code)]
  end

  def work_address_hash
    {
      "2.3 postcode" => format_postcode(work_address_post_code),
      "2.3 number" => work_address_building,
      "2.3 street" => work_address_street,
      "2.3 town city" => work_address_locality,
      "2.3 county" => work_address_county,
      "2.3 phone number" => work_address_telephone_number
    }
  end

  def checkbox(index)
    first_acas_reason_checkbox_for_respondent = [3, 10, 17, 24, 31][@index]
    "Check Box#{first_acas_reason_checkbox_for_respondent + index}"
  end

  def has_acas_number?
    acas_early_conciliation_certificate_number.present?
  end

  def acas_hash
    reason_checkbox = {
      'joint_claimant_has_acas_number' => checkbox(0),
      'acas_has_no_jurisdiction' => checkbox(1),
      'employer_contacted_acas' => checkbox(2),
      'interim_relief' => checkbox(3)
    }[no_acas_number_reason]

    hash = hash_init

    hash[reason_checkbox] = 'Yes' if reason_checkbox
    hash
  end

  def first_respondent?
    @index.zero?
  end

  def hash_init
    {
      HAS_ACAS_CHECKBOXES[@index] => tri_state(has_acas_number?, yes: 'Yes'),
      ACAS_NUMBER_FIELDS[@index] => acas_early_conciliation_certificate_number
    }
  end
end
