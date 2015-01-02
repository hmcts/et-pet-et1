require_relative 'api'

module Jadu
  class Claim < Struct.new(:claim)
    class << self
      def create(claim)
        new(claim).tap &:perform
      end
    end

    def perform
      operation.ok? ? finalize_claim : request_error
    end

    private

    def finalize_claim
      if operation['feeGroupReference']
        claim.update fee_group_reference: operation['feeGroupReference']
      end
      claim.finalize!
    end

    def request_error
      raise StandardError.new <<-EOS.strip_heredoc
        Application #{claim.reference} was rejected by Jadu with error #{operation['errorCode']}
        Description: #{operation['errorDescription']}
        Details: #{operation['details']}
      EOS
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
        o.update filename(a) => a.file.read
      end
    end

    # CarrierWave::Uploader::Base#filename is totally broken, i.e. You can't get
    # the filename unless you assigned that file to that particular instance.
    # If you later query the DB and try to get the filename from that instance
    # it will be nil.
    #
    # This method normalizes the file URL for file and S3 backends. S3 private
    # URLs have query params so can't directly be use with File.basename.

    def filename(attachment)
      File.basename URI.parse(attachment.url).path
    end
  end
end
