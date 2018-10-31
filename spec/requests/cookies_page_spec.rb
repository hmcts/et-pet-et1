require 'rails_helper'

RSpec.describe "Cookies page", type: :request do
  describe "/apply/cookies" do
    include_examples 'google tag manager', page_object_class: ET1::Test::CookiesPage
  end

end
