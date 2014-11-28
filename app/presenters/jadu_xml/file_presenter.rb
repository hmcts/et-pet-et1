module JaduXml
  class FilePresenter < XmlPresenter
    property :filename, as: "Filename", exec_context: :decorator
    property :checksum, as: "Checksum", exec_context: :decorator

    def filename
      File.basename(represented.to_s)
    end

    def checksum
      Digest::MD5.file(represented.path).hexdigest
    end
  end
end
