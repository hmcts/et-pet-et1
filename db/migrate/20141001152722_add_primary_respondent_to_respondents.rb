class AddPrimaryRespondentToRespondents < ActiveRecord::Migration[4.2]
  def change
    add_column :respondents, :primary_respondent, :boolean, default: false
  end
end
