class AddBoolsToRespondent < ActiveRecord::Migration[4.2]
  def change
    add_column :respondents, :was_employed, :boolean
  end
end
