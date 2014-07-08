require 'rails_helper'

RSpec.describe RepresentativeForm, :type => :form do
  describe '#save' do
    let(:model) { Claim.create }
    let(:form) { RepresentativeForm.new(attributes) { |f| f.resource = model } }
    let(:representative) { model.representative }

    let(:attributes) do
      { name: 'Saul Goodman', organisation_name: 'Better Call Saul',
        type: 'citizen_advice_bureau', dx_number: '1',
        address_building: '1', address_street: 'High Street',
        address_locality: 'Anytown', address_county: 'Anyfordshire',
        address_post_code: 'AT1 0AA', email_address: 'lol@example.com' }
    end

    before { form.save }

    describe 'for valid attributes' do
      let(:address) { representative.address }

      it "adds a claimant to the claim" do
        expect(representative.attributes).
          to include("name"=>"Saul Goodman", "organisation_name"=>"Better Call Saul",
                     "type"=>"citizen_advice_bureau", "dx_number"=>"1")
      end

      it "adds an address to the claimaint" do
        expect(address.attributes).
          to include("building"=>"1", "street"=>"High Street",
                     "locality"=>"Anytown", "county"=>"Anyfordshire",
                     "post_code"=>"AT1 0AA")
      end
    end
  end
end
