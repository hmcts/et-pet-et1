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
      case
      when _destroy?
        !!target.destroy
      when valid?
        !!target.update_attributes(attributes)
      else
        false
      end
    end
  end
end
