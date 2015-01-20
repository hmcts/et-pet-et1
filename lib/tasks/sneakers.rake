require 'sneakers/runner'
require 'action_mailer/delivery_job'

task :environment

namespace :sneakers do
  desc "Start processing jobs with all workers"
  task :work  => :environment do
    silence_warnings do
      Rails.application.eager_load! unless Rails.application.config.eager_load
    end

    workers = ActiveJob::Base.subclasses.map do |klass|
      klass.const_set("Wrapper", Class.new(ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper) do
        from_queue klass.queue_name,
                     :headers => {
                       :'x-dead-letter-exchange' => "#{klass.queue_name}-retry"
                     }

      end)
    end

    Sneakers::Runner.new(workers).run
  end
end
