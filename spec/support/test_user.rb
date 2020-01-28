module ET1
  module Test
    module TestUser
      def test_user
        @test_user || raise("test_user used before it was defined")
      end

# rubocop:disable Style/TrivialAccessors
      def test_user=(user)
        @test_user = user
      end
    end
  end
end
RSpec.configure do |c|
  c.include ::ET1::Test::TestUser
end
