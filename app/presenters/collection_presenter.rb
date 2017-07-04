class CollectionPresenter < Presenter
  class << self
    def collection(collection = nil)
      if collection
        @collection = collection
      else
        @collection
      end
    end

    attr_reader :item_presenter

    def present(*attrs)
      klass_name = name.gsub(/Collection/, '')

      klass = Class.new(klass_name.constantize) do
        define_method(:items) { attrs }
        private :items
      end

      @item_presenter = const_set(klass_name, klass)
    end
  end

  def children
    @children ||= target.send(collection).map { |i| item_presenter.new i }
  end

  private

  def items
    super - [:children]
  end

  delegate :collection, :item_presenter, to: :class
end
