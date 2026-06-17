module ET1
  module Test
    module ViewPageObjectSupport
    end
  end
end

RSpec.configure do |c|
  c.include ET1::Test::ViewPageObjectSupport, :fake_capybara_session_with

  c.around(:example, :fake_capybara_session_with) do |example|
    mock_app = proc {
      [200, { 'Content-Type' => 'text/html' }, send(example.metadata[:fake_capybara_session_with])]
    }
    session = Capybara::Session.new(:rack_test, mock_app)
    Capybara.using_session(session) do
      example.run
    end
  end
end
