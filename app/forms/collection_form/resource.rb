module CollectionForm
  class Resource < Form
    boolean :_destroy

    def valid?
      if _destroy?
        true
      else
        super
      end
    end

    def save
      if _destroy?
        !target.destroy.nil?
      elsif valid?
        !target.update(attributes).nil?
      else
        false
      end
    rescue PG::NotNullViolation => e
      report_exception_to_sentry(e, target, attributes)

      raise PG::NotNullViolation, e.message
    end

    private

    def report_exception_to_sentry(exception, target, attributes)
      sentry_data = {
        old_data: target.attributes,
        new_data: attributes
      }

      Sentry.with_scope do |scope|
        scope.set_extras(sentry_data)
        Sentry.capture_exception(exception)
      end
    end
  end
end
