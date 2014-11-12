class PeriodicTask
  def initialize(every:, run_immediately: true)
    @mutex          = Mutex.new
    @stop_next_tick = false
    block           = proc

    @thread = Thread.new do
      Thread.stop unless run_immediately

      loop do
        block.call
        sleep every

        Thread.stop if @mutex.synchronize { @stop_next_tick }
      end
    end
  end

  def run
    @mutex.synchronize { @stop_next_tick = false }
    @thread.run
  end

  def stop
    @mutex.synchronize { @stop_next_tick = true }
  end
end
