class RemoveDefaultFromHasMultipleRespondentsInClaims < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:claims, :has_multiple_respondents, from: false, to: nil)
  end
end
