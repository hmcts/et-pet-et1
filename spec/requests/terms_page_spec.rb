require 'rails_helper'

RSpec.describe "Terms page", type: :request do
  describe "/apply/terms" do
    include_examples 'google tag manager', page_object_class: ET1::Test::TermsPage
  end

end
