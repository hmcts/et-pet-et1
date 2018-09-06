module DiversitiesHelper
  delegate :current_page, :total_pages, to: :page_manager

  def format(text)
    markdown.render(text)
  end

  def diversity_header
    I18n.t("diversities.#{current_step}.hint")
  end

  def diversity_subheader
    I18n.t("diversities.#{current_step}.sub_header", default: '')
  end

  def diversity_title
    page_title(diversity_header)
  end

  def display_ethnicity_subgroup?
    !(resource.ethnicity.blank? || resource.ethnicity == 'prefer-not-to-say')
  end

  def religion_value(object)
    if object.religion_text.blank? && object.religion
      t("simple_form.options.diversities_religion.religion.#{object.religion}")
    elsif object.religion_text
      object.religion_text
    end
  end

  def ethnicity_type_list
    Diversities::EthnicityForm::ETHNICITY.reject { |type| type == 'prefer-not-to-say' }
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
