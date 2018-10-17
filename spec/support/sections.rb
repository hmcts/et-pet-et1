require_relative './sections/base_section'
Dir.glob(File.absolute_path('../sections/**/*.rb', __FILE__)).each { |f| require f }
