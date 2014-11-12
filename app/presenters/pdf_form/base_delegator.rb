module PdfForm
  autoload :ClaimPresenter, 'pdf_form/claim_presenter'
  autoload :EmploymentPresenter, 'pdf_form/employment_presenter'
  autoload :OfficePresenter, 'pdf_form/office_presenter'
  autoload :PrimaryClaimantPresenter, 'pdf_form/primary_claimant_presenter'
  autoload :RepresentativePresenter, 'pdf_form/representative_presenter'
  autoload :RespondentPresenter, 'pdf_form/respondent_presenter'

  class BaseDelegator < SimpleDelegator
    def format_postcode(postcode)
      if postcode.present?
        uk_postcode = UKPostcode.new(postcode)
        ("%-4s" % uk_postcode.outcode) + uk_postcode.incode
      else
        ''
      end
    end

    def use_or_off(field, options)
      field = field.to_s
      options.map(&:to_s).include?(field) ? field : 'Off'
    end

    def tri_state(value, yes: 'yes')
      { nil => 'Off', false => 'no', true => yes }[value]
    end

    def dual_state(value, yes: 'yes')
      { nil => 'Off', false => 'Off', true => yes }[value]
    end

    def self.present(*objects)
      objects.each do |object|
        define_method(object) do
          value = __getobj__.send(object)

          if value
            klass = PdfForm.const_get "#{object}_presenter".classify
            klass.new value
          end
        end
      end
    end
  end
end
