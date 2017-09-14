Dir.glob(File.expand_path('../../sections/**/*.rb', __FILE__)).each do |f|
  require f
end
class BasePage < SitePrism::Page
end
