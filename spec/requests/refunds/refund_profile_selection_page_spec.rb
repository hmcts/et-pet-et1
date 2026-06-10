require 'rails_helper'

RSpec.describe "Refund profile selection page", type: :request do
  describe "/apply/refund/profile-selection" do
    it_behaves_like 'google tag manager', page_object_class: ET1::Test::Refunds::ProfileSelectionPage
  end
end
