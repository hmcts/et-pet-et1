require 'rails_helper'

RSpec.describe "Guides page", type: :request do
  describe "/apply/guide" do
    it_behaves_like 'google tag manager', page_object_class: ET1::Test::GuidePage
  end

end
