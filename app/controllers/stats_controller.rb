class StatsController < ApplicationController
  respond_to :json

  def index
    respond_with statistics
  end

  private

  def statistics
    {
      started_claims: Stats::ClaimStats.started_count,
      completed_claims: Stats::ClaimStats.completed_count
    }
  end
end
