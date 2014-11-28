module JaduXml
  class DocumentIdPresenter < XmlPresenter
    property :name,    as: "DocumentName"
    property :id,      as: "UniqueId"
    property :type,    as: "DocumentType"
    property :time,    as: "TimeStamp"
    property :version, as: "Version"
  end
end
