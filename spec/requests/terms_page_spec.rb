require 'rails_helper'

RSpec.describe "Terms page", type: :request do
  describe "/apply/terms" do
    it_behaves_like 'google tag manager', page_object_class: ET1::Test::TermsPage
  end

end
