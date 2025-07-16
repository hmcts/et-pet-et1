require 'English'
task test: :environment do
  unless system("rspec -t ~smoke --format progress --format RspecJunitFormatter --out tmp/test/rspec.xml")
    raise "Rspec testing failed #{$CHILD_STATUS}"
  end
end

task 'test:smoke' => :environment do
  puts "No smoke tests yet"
end

task 'test:functional' => :environment do
  puts "No functional tests yet"
end
