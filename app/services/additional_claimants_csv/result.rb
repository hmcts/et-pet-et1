class AdditionalClaimantsCsv::Result
  attr_reader :success, :errors
  attr_accessor :csv_header, :line_count

  def initialize
    @success = true
    @line_count = 0
    @errors = []
  end

  def fail(model_errors)
    @success = false
    @errors = model_errors
  end

  def error_line
    @line_count.next
  end
end
