require 'rails_helper'

RSpec.describe "Diversities claim type page", type: :request do
  describe "/apply/diversity/claim-type" do
    include_examples 'google tag manager', page_object_class: ET1::Test::Diversity::ClaimTypePage
  end
end
