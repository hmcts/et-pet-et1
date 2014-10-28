require 'builder'

module Jadu
  autoload :AddressSerializer, 'jadu/address_serializer'
  autoload :ClaimSerializer, 'jadu/claim_serializer'
  autoload :OfficeSerializer, 'jadu/office_serializer'
  autoload :ClaimantSerializer, 'jadu/claimant_serializer'
  autoload :RepresentativeSerializer, 'jadu/representative_serializer'
  autoload :RespondentSerializer, 'jadu/respondent_serializer'
  autoload :PaymentSerializer, 'jadu/payment_serializer'
  autoload :DiversitySerializer, 'jadu/diversity_serializer'

  class BaseSerializer < SimpleDelegator
    def self.present(*objects)
      objects.each do |object|
        define_method(object) do
          value = __getobj__.send(object)

          if value
            klass = Jadu.const_get "#{object}_serializer".classify
            klass.new value
          end
        end
      end
    end
  end
end
