require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      head :ok
    end
  end

  before do
    get :index
  end

  delegate :header, to: :response

  describe "response headers before action" do
    it "sets Cache-Control" do
      expect(header["Cache-Control"]).
        to include "no-cache, no-store"
    end

    it "sets Pragma" do
      expect(header["Pragma"]).to eq "no-cache"
    end

    it "sets Expires" do
      expect(header["Expires"]).to eq "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end
end
