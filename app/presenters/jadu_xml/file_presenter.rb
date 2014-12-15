module JaduXml
  class FilePresenter < XmlPresenter
    property :filename, as: "Filename", exec_context: :decorator
    property :checksum, as: "Checksum", exec_context: :decorator

    def filename
      File.basename(represented.filename)
    end

    def checksum
      Digest::MD5.hexdigest(represented.read)
    end
  end
end
