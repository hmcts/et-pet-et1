class Jadu::DiversitySerializer < Jadu::BaseSerializer
  def to_xml(options={})
    xml = builder(options)
    xml.UserCharacteristics do
      xml.DeclinedToAnswer true
      xml.ClaimType
      xml.Sex
      xml.GenderIdentityBirth
      xml.GenderIdentityNow
      xml.SexualOrientation
      xml.MaritalStatus
      xml.AgeGroup
      xml.CaringResponsibilities
      xml.Religion
      xml.EthnicityPartA
      xml.EthnicityPartB
      xml.Disability
      xml.Pregnancy
    end
  end
end
