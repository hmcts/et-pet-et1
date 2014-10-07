ActionController::Renderers.add :pdf do |obj, options|
  filename = options[:filename] || 'data'
  str = obj.respond_to?(:to_pdf) ? obj.to_pdf : obj.to_s
  send_data str, type: Mime::PDF, disposition: "attachment; filename=#{filename}.pdf"
end
