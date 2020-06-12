require_relative './base'
module Et1
  module Test
    module EmailObjects
      class LostPasswordEmailText < Base
        include RSpec::Matchers

        def self.find(repo: ActionMailer::Base.deliveries, email_address:)
          instances = repo.map { |delivery| new(delivery) }
          instances.detect { |instance| instance.has_correct_subject? && instance.has_correct_to_address?(email_address) }
        end

        def initialize(*args)
          super
          part = mail.parts.detect { |p| p.content_type =~ %r{text/plain} }
          self.body = part.nil? ? '' : part.body.to_s
          self.lines = body.lines.map { |l| l.to_s.strip }
        end

        def has_correct_subject? # rubocop:disable Naming/PredicateName
          mail.subject == "Reset password instructions"
        end

        def has_correct_to_address?(email_address) # rubocop:disable Naming/PredicateName
          mail.to.include?(email_address)
        end

        def has_correct_content_for?(comments:, suggestions:, email_address:) # rubocop:disable Naming/PredicateName
          aggregate_failures 'validating content' do
            expect(has_correct_subject?).to be true
          end
          true
        end

        private

        attr_accessor :body, :lines
      end
    end
  end
end
