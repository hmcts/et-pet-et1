class AddBoolsToRespondent < ActiveRecord::Migration
  def change
    add_column :respondents, :was_employed, :boolean
  end
end
