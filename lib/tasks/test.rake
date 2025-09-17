require 'English'
task test: :environment do
  unless system("rspec -t ~smoke --format progress --format RspecJunitFormatter --out tmp/test/rspec.xml")
    raise "Rspec testing failed #{$CHILD_STATUS}"
  end
end

task 'test:smoke' => :environment do
  if system "bundle exec rspec spec/features/create_claim_applications_spec.rb"
    puts "Smoke test passed"
  else
    raise "Smoke tests failed"
  end
end

task 'test:functional' => :environment do
  puts "No functional tests yet"
end
