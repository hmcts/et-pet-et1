class StatsController < ActionController::Base
  respond_to :json

  def index
    respond_with statistics
  end

  private

  def statistics
    {
      started_count:   Stats::ClaimStats.started_count,
      completed_count: Stats::ClaimStats.completed_count,
      paid_count:      Stats::ClaimStats.paid_count,
      remission_count: Stats::ClaimStats.remission_count
    }
  end
end
