require 'English'

# Override Rails default test task to use RSpec
Rake::Task["test"].clear if Rake::Task.task_defined?("test")

task test: :environment do
  unless system("rspec -t ~smoke --format progress --format RspecJunitFormatter --out tmp/test/rspec.xml")
    raise "Rspec testing failed #{$CHILD_STATUS}"
  end
end

task 'test:smoke' => :environment do
  unless system("rspec -t smoke --format progress --format RspecJunitFormatter --out tmp/test/rspec.xml spec/features/smoke_spec.rb")
    raise "Rspec smoke testing failed #{$CHILD_STATUS}"
  end
end

task 'test:functional' => :environment do
  puts "No functional tests yet"
end
