RSpec::Matchers.define :have_signout_button do
  match { |page| page.has_button? 'Save and complete later' }
end
