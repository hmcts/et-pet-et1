require_relative './base'
module Et1
  module Test
    module EmailObjects
      class ResetPasswordEmailHtml < SitePrism::Page
        include RSpec::Matchers

        # @return [Et1::Test::EmailObjects::ResetPasswordEmailHtml, Nil]
        def self.find(repo: ActionMailer::Base.deliveries, email_address:)
          instances = repo.map { |mail| new(mail) }
          instances.detect { |instance| instance.has_correct_subject? && instance.has_correct_to_address?(email_address) }
        end

        def initialize(mail)
          self.mail = mail
          part = mail.parts.detect { |p| p.content_type =~ %r{text\/html} }
          body = part.nil? ? '' : part.body.to_s
          load(body)
        end

        def has_correct_email_address?
          mail.from.include? "fredbloggs@example.com"
        end

        def has_correct_content_for?(comments:, suggestions:, email_address:) # rubocop:disable Naming/PredicateName
          aggregate_failures 'validating content' do
            expect(has_correct_subject?).to be true
            expect(has_correct_email_address?).to be true
          end
          true
        end

        def has_correct_subject? # rubocop:disable Naming/PredicateName
          mail.subject == "Employment Tribunal: Reset your memorable word"
        end

        def has_correct_to_address?(email_address) # rubocop:disable Naming/PredicateName
          mail.to.include?(email_address)
        end

        def reset_memorable_word_path
          uri = URI.parse(reset_memorable_word_link[:href])
          uri.host = nil
          uri.scheme = nil
          uri.port = nil
          uri.to_s
        end

        private

        element :reset_memorable_word_link, :link, 'Reset my memorable word'

        attr_accessor :mail
      end
    end
  end
end
