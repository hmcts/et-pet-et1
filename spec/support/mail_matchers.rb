module MailMatchers
  extend RSpec::Matchers::DSL

  matcher :match_pattern do |pattern, escape_regex: true|
    # If a mail has an attachment it is multipart, i.e. content and attachment,
    # the content can also be multipart, e.g. html and plain text. This matcher
    # will recurse if there is an attachment to make sure that all content parts
    # have the given text.

    pattern = Regexp.escape(pattern) if escape_regex

    def _match(mail, pattern)
      if mail.parts.any?(&:multipart?)
        _match mail.parts.find(&:multipart?), pattern
      else
        mail.parts.all? { |part| part.body.match pattern }
      end
    end

    match { |mail| _match mail, pattern }
  end
end
