module Refunds
  class ReviewForm < Form
    attribute :accept_declaration, :boolean
    before_save :generate_application_reference, unless: :target_frozen?
    before_save :generate_submitted_date, unless: :target_frozen?
    after_save :persist_refund_id_into_session

    validates :accept_declaration, acceptance: { accept: true }

    def initialize(resource, &block)
      self.refund_session = resource
      super(Refund.new(resource.to_h.except('_refund_id')), &block)
    end

    def method_missing(method, *args)
      return resource.send(method, *args) if !method.to_s.end_with?('=') && resource.respond_to?(method)

      super
    end

    def respond_to_missing?(method, *args)
      return true if !method.to_s.end_with?('=') && resource.respond_to?(method)

      super
    end

    private

    attr_accessor :refund_session

    def generate_application_reference
      resource.generate_application_reference
    end

    def generate_submitted_date
      resource.generate_submitted_at
    end

    def target_frozen?
      target.frozen?
    end

    def persist_refund_id_into_session
      refund_session._refund_id = resource.id
      refund_session.save!
    end
  end
end
