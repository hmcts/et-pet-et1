module JaduXml
  class DocumentId
    attr_reader :name, :id, :type, :time, :version

    def initialize
      @name = "ETFeesEntry"
      @id = Time.zone.now.to_s(:number)
      @type = "ETFeesEntry"
      @time = Time.zone.now.xmlschema
      @version = 1
    end
  end
end
