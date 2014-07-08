require 'rails_helper'

RSpec.describe RespondentForm, :type => :form do
  describe '#save' do
    let(:model) { Claim.create }
    let(:form) { RespondentForm.new(attributes) { |f| f.resource = model } }
    let(:respondent) { model.respondents.first }

    let(:attributes) do
      { "name" => "Crappy Co. LTD",
        "address_telephone_number" => "01234567890", "address_building" => "1",
        "address_street" => "Business Street", "address_locality" => "Businesstown",
        "address_county" => "Businessfordshire", "address_post_code" => "BT1 1CB",
        "work_address_building" => "2", "work_address_street" => "Business Lane",
        "work_address_locality" => "Business City", "work_address_county" => 'Businessbury',
        "work_address_post_code" => "BT2 1CB", "work_address_telephone_number" => "01234000000",
        "worked_at_different_address" => '1', "no_acas_number" => "1",
        "no_acas_number_reason" => "acas_has_no_jurisdiction" }
    end

    before { form.save }

    describe 'for valid attributes' do
      let(:address)      { respondent.addresses.first }
      let(:work_address) { respondent.addresses.last }

      it "adds a respondent to the claim" do
        expect(respondent.attributes).
          to include("name" => "Crappy Co. LTD",
                     "no_acas_number_reason" => "acas_has_no_jurisdiction")
      end

      it "adds a primary address to the respondent" do
        expect(address.attributes).
          to include("building"=>"1", "street"=>"Business Street",
                     "locality"=>"Businesstown", "county"=>"Businessfordshire",
                     "post_code"=>"BT1 1CB")
      end

      it "adds a work address to the respondent" do
        expect(work_address.attributes).
          to include("building"=>"2", "street"=>"Business Lane",
                     "locality"=>"Business City", "county"=>"Businessbury",
                     "post_code"=>"BT2 1CB")
      end
    end
  end
end
