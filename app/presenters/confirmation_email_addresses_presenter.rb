class ConfirmationEmailAddressesPresenter
  delegate :primary_claimant, :representative, :secondary_claimants, to: :claim

  attr_reader :claim

  def initialize(claim)
    @claim = claim
  end

  def self.email_addresses_for(claim)
    new(claim).filter_email_addresses
  end

  def filter_email_addresses
    [primary_claimant_email, representative_email].
      reject { |email| email.last.blank? }
  end

  private

  def primary_claimant_email
    [tick_primary_claimant?, primary_claimant.email_address]
  end

  def representative_email
    [true, representative.try(:email_address)]
  end

  def tick_primary_claimant?
    secondary_claimants.none? || representative.try(:email_address).blank?
  end
end
