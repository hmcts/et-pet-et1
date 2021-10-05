require 'gov_fake_notify'
RSpec.configure do |c|
  c.before(:each) do
    GovFakeNotify.reset!
  end
end
GovFakeNotify.config do |c|
  c.delivery_method = :test
  c.include_templates = [
    {
      id: '017d71e6-498b-4d07-b77d-536b8b3f54dc',
      name: 'et1-access-details-v1-en',
      subject: 'Employment tribunal: complete your claim',
      message: <<~EOS
        Claim number: ((reference))
        You’ve started a claim to an employment tribunal. To return to your claim you’ll need your claim number (above), and memorable word.
        ---
        Clicking on the links below will not work. Please copy and paste the URLs into your browser.
        COMPLETE CLAIM: ((url))
        ---
        You’ll receive a confirmation email once you’ve submitted your claim.
        ---
        Contact us: http://www.justice.gov.uk/contacts/hmcts/tribunals/employment
      EOS

    },
    {
      id: '97a117f1-727d-4631-bbc6-b2bc98d30a0f',
      name: 'et1-access-details-v1-cy',
      subject: 'Tribiwnlys Cyflogaeth: cwblhau eich hawliad',
      message: <<~EOS
        Rhif yr hawliad: ((reference))
        Rydych wedi cychwyn gwneud hawliad i dribiwnlys cyflogaeth. I ddychwelyd i'ch hawliad byddwch angen eich rhif hawliad (uchod), a'ch gair cofiadwy.
        ---
        Ni fydd clicio ar y dolenni isod yn gweithio. Copïwch a gludwch yr URL i'ch porwr.
        CWBLHAU EICH HAWLIAD: ((url))
        ---
        Fe gewch neges e-bost fel cadarnhad unwaith y byddwch wedi cyflwyno'ch hawliad.
        ---
        Cysylltwch â ni: http://www.justice.gov.uk/contacts/hmcts/tribunals/employment
      EOS
    }
  ]
  c.include_api_keys = [
    {
      service_name: 'Employment Tribunals',
      service_email: 'employmenttribunals@email.com',
      key: Rails.application.config.govuk_notify.test_api_key
    }
  ]
end