task :test => :environment do
  unless system("rspec --format RspecJunitFormatter --out tmp/test/rspec.xml")
    raise "Rspec testing failed #{$?}"
  end
end
