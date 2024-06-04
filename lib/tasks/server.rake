require 'timeout'

namespace :server do
  desc 'Start the server'
  task start: :db_migrate do
    require 'puma/cli'

    cli = Puma::CLI.new(['--port', '8080'])
    cli.run
  end

  desc 'Migrate the database with locking so only one process can run it at a time'
  task db_migrate: :environment do
    begin
      Timeout::timeout(50) do
        Rake::Task["db:migrate"].invoke
      end
    rescue Timeout::Error
      Rails.logger.error("Migration task timed out after 50 seconds.")
    rescue ActiveRecord::ConcurrentMigrationError => e
      # Log the error message and ignore
      Rails.logger.error("Concurrent migration error ignored: #{e.message}")
    end
  end
end
