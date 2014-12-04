require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      render nothing: true
    end
  end

  before do
    get :index
  end

  delegate :header, to: :response

  describe "response headers before action" do
    it "sets Cache-Control" do
      expect(header["Cache-Control"]).
        to eq "no-cache, no-store, max-age=0, must-revalidate"
    end

    it "sets Pragma" do
      expect(header["Pragma"]).to eq "no-cache"
    end

    it "sets Expires" do
      expect(header["Expires"]).to eq "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end
end
