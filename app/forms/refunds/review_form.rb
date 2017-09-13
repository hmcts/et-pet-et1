module Refunds
  class ReviewForm < Form
    attribute :accept_declaration,  Boolean
    def method_missing(method, *args)
      return resource.send(method, *args) if !method.to_s.end_with?('=') && resource.respond_to?(method)
      super
    end
  end
end
