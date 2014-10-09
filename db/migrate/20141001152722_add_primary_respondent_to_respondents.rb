class AddPrimaryRespondentToRespondents < ActiveRecord::Migration
  def change
    add_column :respondents, :primary_respondent, :boolean, default: false
  end
end
