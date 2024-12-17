module ApplicationHelper
  def page_title(header = generic_header)
    "#{header} - Gov.uk"
  end

  def yes_no(val)
    return if val.nil?

    I18n.t "shared.#{val ? 'yes' : 'no'}"
  end

  def path_only(url)
    return nil if url.nil?

    URI.parse(url).tap do |uri|
      uri.host = nil
      uri.port = nil
      uri.scheme = nil
    end.to_s
  end

  private

  def generic_header
    I18n.t("#{controller_path.gsub('/', '.')}.#{action_name}.header")
  end
end
