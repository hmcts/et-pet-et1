class RepresentativeForm < Form
  include AddressAttributes

  attribute :type,               String
  attribute :name,               String
  attribute :organisation_name,  String
  attribute :mobile_number,      String
  attribute :email_address,      String
  attribute :dx_number,          String
  attribute :contact_preference, String

  boolean :has_representative

  before_validation :destroy_target!, unless: :has_representative?

  validates :type, :name, presence: true
  validates :type, inclusion: { in: RepresentativeType::TYPES }
  validates :organisation_name, :name, length: { maximum: 100 }
  validates :dx_number, length: { maximum: 40 }
  validates :mobile_number, length: { maximum: PHONE_NUMBER_LENGTH }
  validates :email_address, email: true, allow_blank: true

  def valid?
    if has_representative?
      super
    else
      run_callbacks(:validation) { true }
    end
  end

  def has_representative
    @has_representative ||= target.persisted?
  end

  def target
    resource.representative || resource.build_representative
  end

  private

  def destroy_target!
    target.destroy
  end
end
