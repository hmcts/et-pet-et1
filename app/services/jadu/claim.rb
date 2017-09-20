require_relative 'api'
module Jadu
  class Claim
    attr_reader :claim

    def initialize(claim)
      @claim = claim
    end

    class << self
      def create(claim)
        new(claim).tap(&:perform)
      end
    end

    def perform
      if operation.ok?
        claim.create_event Event::RECEIVED_BY_JADU
        finalize_claim
      else
        claim.create_event Event::REJECTED_BY_JADU,
          message: operation.
            values_at('errorCode', 'errorDescription', 'details').
            select(&:present?).join(' ')

        request_error
      end
    end

    private

    def finalize_claim
      if operation['feeGroupReference']
        claim.update fee_group_reference: operation['feeGroupReference']
      end
      claim.finalize!
    end

    def request_error
      raise jadu_error
    end

    def operation
      @operation ||= client.new_claim(serialized_claim, attachments)
    end

    def serialized_claim
      JaduXml::ClaimPresenter.new(claim).to_xml
    end

    def client
      API.new ENV.fetch('JADU_API')
    end

    def attachments
      @attachments ||= claim.attachments.reduce({}) do |o, a|
        o.update CarrierwaveFilename.for(a, underscore: true) => a.file.read
      end
    end

    def jadu_error
      StandardError.new <<-EOS.strip_heredoc
        Application #{claim.reference} was rejected by Jadu with error #{operation['errorCode']}
        Description: #{operation['errorDescription']}
        Details: #{operation['details']}
      EOS
    end
  end
end
