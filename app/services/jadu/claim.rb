require_relative 'api'

module Jadu
  class Claim < Struct.new(:claim)
    class << self
      def create(claim)
        new(claim).tap &:perform
      end
    end

    def perform
      if operation.ok?
        claim.update fee_group_reference: operation['feeGroupReference'] if operation['feeGroupReference']
        claim.finalize!
      else
        raise StandardError.new <<-EOS.strip_heredoc
          Application #{claim.reference} was rejected by Jadu with error #{operation['errorCode']}
          Description: #{operation['errorDescription']}
          Details: #{operation['details']}
        EOS
      end
    end

    private

    def operation
      @operation ||= client.new_claim(serialized_claim, attachments)
    end

    def serialized_claim
      JaduXml::ClaimPresenter.new(claim).to_xml
    end

    def client
      API.new ENV.fetch('JADU_API_HOST')
    end

    def attachments
      @attachments ||= claim.attachments.reduce({}) do |o, a|
        o.update File.basename(a.url) => a.file.read
      end
    end

    def filename_for(attachment)
      File.basename claim.send(attachment).url
    end

    def file_contents_for(attachment)
      claim.send(attachment).file.read
    end
  end
end
