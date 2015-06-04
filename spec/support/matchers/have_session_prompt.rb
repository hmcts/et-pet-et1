RSpec::Matchers.define :have_session_prompt do
  match { |page| page.body.match(Regexp.escape('sessionPrompt.init();')) }
end
