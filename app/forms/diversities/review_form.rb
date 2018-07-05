module Diversities
  class ReviewForm < Form
    after_save :persist_diversity_id_into_session

    validates :accept_declaration, acceptance: { accept: true }

    def initialize(resource, &block)
      self.diversity_session = resource
      super(Diversity.new(resource.to_h.except('_diversity_id')), &block)
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

    attr_accessor :diversity_session

    def generate_submitted_date
      resource.generate_submitted_at
    end

    def target_frozen?
      target.frozen?
    end

    def persist_diversity_id_into_session
      diversity_session._diversity_id = resource.id
      diversity_session.save!
    end
  end
end
