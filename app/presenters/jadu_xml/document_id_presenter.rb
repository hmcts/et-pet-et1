module JaduXml
  class DocumentIdPresenter < XmlPresenter
    property :name,    as: "DocumentName", exec_context: :decorator
    property :id,      as: "UniqueId", exec_context: :decorator
    property :type,    as: "DocumentType", exec_context: :decorator
    property :time,    as: "TimeStamp", exec_context: :decorator
    property :version, as: "Version", exec_context: :decorator

    def name
      "ETFeesEntry"
    end

    def id
      Time.zone.now.to_s(:number)
    end

    def type
      "ETFeesEntry"
    end

    def time
      Time.zone.now.xmlschema
    end

    def version
      1
    end
  end
end
