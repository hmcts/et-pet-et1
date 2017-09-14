module Refunds
  class ReviewForm < Form
    attribute :accept_declaration,  Boolean
    before_save :generate_application_reference
    def method_missing(method, *args)
      return resource.send(method, *args) if !method.to_s.end_with?('=') && resource.respond_to?(method)
      super
    end

    private

    def generate_application_reference
      resource.generate_application_reference
    end
  end
end
