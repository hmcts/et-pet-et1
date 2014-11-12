class AdditionalRespondentsForm < Form
  boolean :has_additional_respondents

  before_validation :reset_additional_respondents!, unless: :has_additional_respondents

  def has_additional_respondents
    if defined? @has_additional_respondents
      @has_additional_respondents
    else
      @has_additional_respondents = relation.any? &:persisted?
    end
  end

  def respondents_attributes=(attributes)
    attributes.each_with_index do |(_, respondent_attributes), index|
      respondent = relation[index] || relation.build

      respondents[index] = AdditionalRespondentsForm::AdditionalRespondent.new(respondent) do |c|
        c.assign_attributes respondent_attributes
      end
    end
  end

  def respondents
    @respondents ||= relation.tap { |c| c.build if c.empty? }.
      map { |c| AdditionalRespondentsForm::AdditionalRespondent.new(c) }
  end

  def build_child
    @respondents << AdditionalRespondentsForm::AdditionalRespondent.new(relation.build)
  end

  def save
    if valid?
      run_callbacks(:save) { respondents.all?(&:save) }
    else
      false
    end
  end

  def valid?
    run_callbacks(:validation) { super && respondents.map(&:valid?).all? }
  end

  def errors
    respondents.each_with_object(super) do |respondent, errors|
      errors.add(:respondents, respondent.errors)
    end
  end

  private

  def relation
    resource.secondary_respondents
  end

  def reset_additional_respondents!
    relation.destroy_all
    respondents.clear
  end
end
