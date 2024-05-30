namespace :server do
  desc 'Start the server'
  task start: :db_migrate do
    require 'puma/cli'

    cli = Puma::CLI.new(['--port', '8080'])
    cli.run
  end

  desc 'Migrate the database with locking so only one process can run it at a time'
  task db_migrate: :environment do
    result = ActiveRecord::Base.connection.execute <<-SQL
      SELECT pg_try_advisory_lock(1);
    SQL

    if result.first['pg_try_advisory_lock']
      puts 'Acquired lock, running migrations...'
      Rake::Task['db:migrate'].invoke
      puts 'Migrations complete.'

      # Release the lock
      ActiveRecord::Base.connection.execute <<-SQL
        SELECT pg_advisory_unlock(1);
      SQL
    else
      puts 'Could not acquire lock, skipping migrations.'
    end
  end
end
