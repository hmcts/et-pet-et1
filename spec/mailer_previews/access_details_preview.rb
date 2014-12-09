class AccessDetailsPreview < ActionMailer::Preview
  def access_details_email
    BaseMailer.access_details_email(Claim.new)
  end
end
