require_relative './base'
module Et1
  module Test
    module EmailObjects
      class FeedbackEmailText < Base
        include RSpec::Matchers

        def self.find(repo: ActionMailer::Base.deliveries, email_address:)
          instances = repo.map { |delivery| new(delivery) }
          instances.detect { |instance| instance.has_correct_subject? }
        end

        def initialize(*args)
          super
          part = mail.parts.detect { |p| p.content_type =~ %r{text/plain} }
          self.body = part.nil? ? '' : part.body.to_s
          self.lines = body.lines.map { |l| l.to_s.strip }
        end

        def has_correct_subject? # rubocop:disable Naming/PredicateName
          mail.subject == "New ATET User Feedback"
        end

        def has_correct_to_address? # rubocop:disable Naming/PredicateName
          mail.to.include?("fake@servicenow.fake.com")
        end

        def has_correct_content_for?(comments:, suggestions:, email_address:) # rubocop:disable Naming/PredicateName
          aggregate_failures 'validating content' do
            assert_comments(comments)
            assert_suggestions(suggestions)
            expect(has_correct_subject?).to be true
            expect(has_correct_to_address?).to be true
          end
          true
        end

        private

        def assert_comments(comments)
          lines.detect {|l| l == comments}
        end

        def assert_suggestions(suggestions)
          lines.detect {|l| l == suggestions}
        end


        attr_accessor :body, :lines, :template_reference
      end
    end
  end
end
