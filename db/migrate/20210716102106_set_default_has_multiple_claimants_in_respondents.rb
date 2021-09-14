class SetDefaultHasMultipleClaimantsInRespondents < ActiveRecord::Migration[6.1]
  def change
    change_column_default :claims, :has_multiple_respondents, from: nil, to: false
  end
end
