class RepresentativeForm < Form
  TYPES = %w<citizen_advice_bureau free_representation_unit
    law_centre trade_union lawyer private_individual trade_association other>.freeze

  include AddressAttributes

  attributes :type, :organisation_name, :name,
             :mobile_number, :email_address, :dx_number,
             :contact_preference

  boolean :has_representative

  before_validation :destroy_target!, unless: :has_representative?

  validates :type, :name, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :organisation_name, :name, length: { maximum: 100 }
  validates :dx_number, length: { maximum: 20 }
  validates :mobile_number, length: { maximum: PHONE_NUMBER_LENGTH }

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

  private

  def destroy_target!
    target.destroy
  end

  def target
    resource.representative || resource.build_representative
  end
end
