module Reference

  def self.included(base)
    base.class_eval do
      def self.find_by_reference(reference)
        find_by application_reference: ApplicationReference.normalize(reference)
      end
    end
  end

  def reference
    application_reference
  end

  private

  def generate_application_reference
    self.application_reference ||= unique_application_reference
  end

  def unique_application_reference
    loop do
      ref = ApplicationReference.generate
      return ref unless self.class.exists?(application_reference: ref)
    end
  end
end
