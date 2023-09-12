require 'rails_helper'

RSpec.describe "Check JSON Status", type: :request do
  describe "/health" do
    it "responds with status" do
      get '/health'

      expect(JSON.parse(response.body, symbolize_names: true)).to eq(status: "ok")
    end
  end

  describe "/health/readiness" do
    it "responds with status" do
      get '/health/readiness'

      expect(JSON.parse(response.body, symbolize_names: true)).to eq(status: "ok")
    end
  end

  describe "/health/liveness" do
    it "responds with status" do
      get '/health/liveness'

      expect(JSON.parse(response.body, symbolize_names: true)).to eq(status: "ok")
    end
  end
end
