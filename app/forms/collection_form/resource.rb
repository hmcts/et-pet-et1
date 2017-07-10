class CollectionForm
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
        !target.update_attributes(attributes).nil?
      else
        false
      end
    end
  end
end
