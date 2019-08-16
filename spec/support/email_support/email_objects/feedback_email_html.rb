require_relative './base'
module Et1
  module Test
    module EmailObjects
      class FeedbackEmailHtml < SitePrism::Page
        include RSpec::Matchers

        def self.find(repo: ActionMailer::Base.deliveries, email_address:)
          instances = repo.map { |mail| FeedbackEmailHtml.new(mail) }
          instances.detect { |instance| instance.has_correct_subject? && instance.has_correct_email_address?(email_address) }
        end

        def initialize(mail)
          self.mail = mail
          part = mail.parts.detect { |p| p.content_type =~ %r{text\/html} }
          body = part.nil? ? '' : part.body.to_s
          load(body)
        end

        def has_correct_email_address?(email_address)
          mail.from.include? email_address
        end

        def has_correct_content_for?(comments:, suggestions:, email_address:) # rubocop:disable Naming/PredicateName
          aggregate_failures 'validating content' do
            assert_comments_element(comments)
            assert_suggestions_element(suggestions)
            assert_from_element(email_address)
            expect(has_correct_subject?).to be true
            expect(has_correct_to_address?).to be true
          end
          true
        end

        def has_correct_subject? # rubocop:disable Naming/PredicateName
          mail.subject == "New ATET User Feedback"
        end

        private

        def has_correct_to_address? # rubocop:disable Naming/PredicateName
          mail.to.include?("fake@servicenow.fake.com")
        end

        def assert_comments_element(comments)
          assert_selector(:css, 'p', text: comments, wait: 0)
        end

        def assert_suggestions_element(suggestions)
          assert_selector(:css, 'p', text: suggestions, wait: 0)
        end

        def assert_from_element(email_address)
          assert_selector(:css, 'p', text: "The following feedback is from #{email_address}(ET User)")
        end

        attr_accessor :mail
      end
    end
  end
end
