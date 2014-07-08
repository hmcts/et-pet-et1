require 'rails_helper'

RSpec.describe ClaimantForm, :type => :form do
  describe '#save' do
    let(:model) { Claim.create }
    let(:form) { ClaimantForm.new(attributes) { |f| f.resource = model } }
    let(:claimant) { model.claimants.first }

    let(:attributes) do
      { title: 'mr', gender: 'male', contact_preference: 'email',
        first_name: 'Barrington', last_name: 'Wrigglesworth',
        address_building: '1', address_street: 'High Street',
        address_locality: 'Anytown', address_county: 'Anyfordshire',
        address_post_code: 'AT1 0AA', email_address: 'lol@example.com' }
    end

    before { form.save }

    describe 'for valid attributes' do
      let(:address) { claimant.address }

      it "adds a claimant to the claim" do
        expect(claimant.attributes).
          to include("title"=>"mr", "gender"=>"male", "contact_preference"=>"email",
                     "first_name"=>"Barrington", "last_name"=>"Wrigglesworth",
                     "email_address"=>"lol@example.com")
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
