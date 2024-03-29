Rails.application.config.to_prepare do
  ActiveRecord::Type.register(:gds_date_type, GdsDateType)
  ActiveRecord::Type.register(:et_date, EtDateType)
  ActiveRecord::Type.register(:attachment_uploader_type, AttachmentUploaderType)
  ActiveRecord::Type.register(:array_type, ArrayType)
  ActiveRecord::Type.register(:array_of_strings_type, ArrayOfStringsType)
end
