module DiversitiesHelper
  delegate :current_page, :total_pages, to: :page_manager

  def format(text)
    markdown.render(text)
  end

  def diversity_header
    if current_step == 'ethnicity_subgroup'
      @diversity_session[:data]['ethnicity']
    else
      I18n.t("diversities.#{current_step}.hint")
    end
  end

  def diversity_title
    page_title(diversity_header)
  end

  def display_ethnicity_subgroup?
    !(resource.ethnicity.blank? || resource.ethnicity == t('diversities.ethnicity.options').last)
  end

  def religion_value(object)
    return object.religion if object.religion_text.blank?
    "#{object.religion}: #{object.religion_text}"
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
